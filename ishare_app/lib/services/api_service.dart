import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/trip_model.dart';
import '../models/booking_model.dart';

// ⚠️ NETWORK CONFIGURATION
const String baseUrl = "https://amiable-amazement-production-4d09.up.railway.app";

class ApiService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isRefreshing = false; 

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Web-specific configuration for CORS
    if (kIsWeb) {
      _dio.options.headers['Content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          debugPrint('🔑 Token attached to request: ${options.uri}');
        } else {
          debugPrint('⚠️ No token found - proceeding without auth: ${options.uri}');
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // IMPROVED ERROR LOGGING: Captures the specific server message
        if (e.response != null) {
          debugPrint('❌ API Error: ${e.response?.statusCode} - ${e.response?.data}');
        } else {
          debugPrint('❌ Network Error: ${e.message}');
        }
        
        if (e.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;
          debugPrint('🔄 Attempting token refresh...');
          
          try {
            final refreshed = await _refreshToken();
            if (refreshed) {
              try {
                final token = await _storage.read(key: 'access_token');
                e.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(e.requestOptions);
                return handler.resolve(response);
              } catch (retryError) {
                return handler.next(e);
              }
            } else {
              await logout();
              return handler.next(e);
            }
          } finally {
            _isRefreshing = false;
          }
        }
        return handler.next(e);
      },
    ));
  } 

  // =====================================================
  // 1. AUTHENTICATION & PASSWORD RESET
  // =====================================================

  Future<Response> login({
    required String username, 
    required String password,
    required String role, 
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/token/', 
        data: {
          'username': username, 
          'password': password,
          'role': role 
        },
      );

      if (response.statusCode == 200) {
        await _storage.write(key: 'access_token', value: response.data['access']);
        await _storage.write(key: 'refresh_token', value: response.data['refresh']);
        await _storage.write(key: 'user_role', value: role); 
        debugPrint('✅ Login successful (Token & Role Saved)');
      }
      return response; 
    } catch (e) {
      debugPrint('❌ Login failed: $e');
      rethrow;
    }
  }

  // ✅ FIXED REGISTER: Now throws detailed server validation errors
  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? vehicleModel,
    String? plateNumber,
    XFile? vehiclePhoto, 
  }) async {
    try {
      final Map<String, dynamic> dataMap = {
        'username': username,
        'password': password,
        'password2': password,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
      };

      if (role == 'driver') {
        if (vehicleModel != null) dataMap['vehicle_model'] = vehicleModel;
        if (plateNumber != null) dataMap['plate_number'] = plateNumber;
      }

      final formData = FormData.fromMap(dataMap);

      if (vehiclePhoto != null) {
        final bytes = await vehiclePhoto.readAsBytes();
        formData.files.add(MapEntry(
          'vehicle_photo', 
          MultipartFile.fromBytes(bytes, filename: vehiclePhoto.name),
        ));
      }

      final response = await _dio.post(
        '/api/register/', 
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 201) {
        debugPrint('✅ Registration successful');
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        // This print statement is crucial for your 400 error debugging
        debugPrint('❌ SERVER REJECTION: ${e.response?.data}');
        throw Exception('Registration failed: ${e.response?.data}');
      }
      debugPrint('❌ Registration failed: $e');
      rethrow;
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(
        '/api/auth/forgot-password/', 
        data: {'email': email}
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) return;
      rethrow;
    }
  }

  Future<void> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/api/auth/reset-password/', 
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
        },
      );
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        throw Exception(e.response?.data['error'] ?? "Reset failed");
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_role');
    _isRefreshing = false;
    debugPrint('✅ Logged out - tokens cleared');
  }
  
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) return false;
      
      final refreshDio = Dio();
      refreshDio.options.baseUrl = baseUrl;
      
      final response = await refreshDio.post(
        '/api/auth/token/refresh/', 
        data: {'refresh': refreshToken},
      );
      
      if (response.statusCode == 200) {
        await _storage.write(key: 'access_token', value: response.data['access']);
        if (response.data.containsKey('refresh')) {
          await _storage.write(key: 'refresh_token', value: response.data['refresh']);
        }
        return true;
      }
    } catch (e) {
      debugPrint('❌ Token refresh error: $e');
    }
    return false;
  }

  // =====================================================
  // 2. TRIPS & BOOKINGS
  // =====================================================

  Future<List<TripModel>> fetchTrips() async {
    try {
      final response = await _dio.get('/api/trips/');
      final List<dynamic> data = response.data;
      return data.map((trip) => TripModel.fromJson(trip)).toList();
    } catch (e) {
      debugPrint('❌ Failed to fetch trips: $e');
      rethrow;
    }
  }

  Future<List<TripModel>> getMyTrips() async {
    try {
      final response = await _dio.get('/api/trips/my_trips/');
      final List<dynamic> data = response.data;
      return data.map((json) => TripModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching my trips: $e');
      rethrow;
    }
  }

  Future<List<BookingModel>> fetchMyBookings() async {
    try {
      final response = await _dio.get('/api/bookings/my_tickets/');
      final List<dynamic> data = response.data;
      return data.map((booking) => BookingModel.fromJson(booking)).toList();
    } catch (e) {
      debugPrint('❌ Failed to fetch bookings: $e');
      rethrow;
    }
  }

  // =====================================================
  // 3. DRIVER REQUESTS
  // =====================================================

  Future<List<BookingModel>> getDriverRequests() async {
    try {
      final response = await _dio.get('/api/bookings/driver-requests/');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load requests");
      }
    } catch (e) {
      throw Exception("Error fetching requests: $e");
    }
  }

  Future<void> approveBooking(int bookingId) async {
    try {
      await _dio.post('/api/bookings/$bookingId/approve/');
    } catch (e) {
      throw Exception("Failed to approve: $e");
    }
  }

  Future<void> rejectBooking(int bookingId) async {
    try {
      await _dio.post('/api/bookings/$bookingId/reject/');
    } catch (e) {
      throw Exception("Failed to reject: $e");
    }
  }

  // =====================================================
  // 4. USER PROFILE & VERIFICATION
  // =====================================================
  Future<UserProfileModel> fetchMyProfile() async {
    try {
      final response = await _dio.get('/api/profiles/me/');
      return UserProfileModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    try {
      final formMap = <String, dynamic>{};
      data.forEach((key, value) {
        if (value != null && value is! XFile) formMap[key] = value;
      });

      final formData = FormData.fromMap(formMap);

      if (data['profile_picture'] != null && data['profile_picture'] is XFile) {
        final XFile file = data['profile_picture'];
        final bytes = await file.readAsBytes();
        formData.files.add(MapEntry('profile_picture', MultipartFile.fromBytes(bytes, filename: file.name)));
      }

      if (data['vehicle_photo'] != null && data['vehicle_photo'] is XFile) {
        final XFile file = data['vehicle_photo'];
        final bytes = await file.readAsBytes();
        formData.files.add(MapEntry('vehicle_photo', MultipartFile.fromBytes(bytes, filename: file.name)));
      }

      final response = await _dio.patch(
        '/api/profiles/me/',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return UserProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('❌ UPDATE PROFILE ERROR: ${e.response?.data}');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> submitDriverVerification(Map<String, dynamic> data) async {
    try {
      final formData = FormData();

      for (var entry in data.entries) {
        if (entry.value is XFile) {
          final XFile file = entry.value;
          final bytes = await file.readAsBytes();
          formData.files.add(MapEntry(
            entry.key,
            MultipartFile.fromBytes(bytes, filename: file.name),
          ));
        } else if (entry.value != null) {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }

      await _dio.post('/api/driver/verify/', data: formData);
      debugPrint('✅ Verification submitted successfully');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkDriverVerification() async {
    try {
      final response = await _dio.get('/api/driver/verification-status/');
      final data = response.data ?? {};
      final statusStr = data['status']?.toString().toLowerCase();
      final isVerified = data['is_verified'] == true || statusStr == 'approved';
      
      return {
        'is_verified': isVerified,
        'status': statusStr ?? 'none',
        'has_pending': statusStr == 'pending',
      };
    } catch (e) {
      rethrow;
    }
  }

  // =====================================================
  // 5. CREATE, RATE & PAYMENTS
  // =====================================================

  Future<TripModel> createTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await _dio.post('/api/trips/', data: tripData);
      return TripModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<BookingModel> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _dio.post('/api/bookings/', data: bookingData);
      return BookingModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // ✅ FIXED PAYMENT: Uses 'booking_id' to match Python view logic
  Future<Map<String, dynamic>> simulatePayment({
    required int bookingId,
    required double amount,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/api/payments/',
        data: {
          'booking_id': bookingId, // Changed to match your Python request.data.get('booking_id')
          'amount': amount.toString(),
          'payment_method': 'mobile_money',
          'phone_number': phoneNumber,
        },
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ PAYMENT FAILED - SERVER SAYS: ${e.response?.data}");
      }
      rethrow;
    }
  }

  Future<void> submitRating(Map<String, dynamic> data) async {
    try {
      await _dio.post('/api/ratings/', data: data);
      debugPrint('✅ Rating submitted successfully');
    } catch (e) {
      rethrow;
    }
  }

  // =====================================================
  // 6. SUBSCRIPTION METHODS
  // =====================================================

  Future<List<dynamic>> fetchSubscriptionPlans() async {
    try {
      final response = await _dio.get('/api/subscriptions/plans/');
      return response.data; 
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to load plans");
    }
  }

  Future<void> activateSubscription(int planId) async {
    try {
      await _dio.post(
        '/api/subscriptions/subscribe/',
        data: {'plan_id': planId},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to activate subscription");
    }
  }

  Future<void> submitSubscriptionPayment(int planId, String transactionId) async {
    try {
      await _dio.post(
        '/api/subscriptions/pay/', 
        data: {
          'plan_id': planId,
          'transaction_id': transactionId,
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to submit payment");
    }
  }

  Future<Map<String, dynamic>> checkSubscriptionAccess() async {
    try {
      final response = await _dio.get('/api/subscriptions/me/');
      final bool isValid = response.data['is_valid'] == true;
      return {
        'has_access': isValid,
        'status': isValid ? 'active' : 'inactive',
        'is_valid': isValid,
      };
    } catch (e) {
      return {'has_access': false, 'is_valid': false};
    }
  }
}

// =====================================================
// ✅ RIVERPOD PROVIDERS
// =====================================================

final apiServiceProvider = Provider((ref) => ApiService());

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.isLoggedIn();
});

final tripsProvider = FutureProvider<List<TripModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.fetchTrips();
});

final myTripsProvider = FutureProvider<List<TripModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getMyTrips(); 
});

final bookingsProvider = FutureProvider<List<BookingModel>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.fetchMyBookings();
});

final userProfileProvider = FutureProvider.autoDispose<UserProfileModel>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.fetchMyProfile();
});