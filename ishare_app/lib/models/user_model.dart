// lib/models/user_model.dart

// ✅ 1. Review Model (Helper for the list)
class ReviewModel {
  final int id;
  final String raterName;
  final String? raterAvatar;
  final double score;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.raterName,
    this.raterAvatar,
    required this.score,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? 0, // Safety default
      raterName: json['rater_name'] ?? "User",
      raterAvatar: json['rater_avatar'],
      score: (json['score'] as num?)?.toDouble() ?? 5.0,
      comment: json['comment'] ?? "",
      // Safety check for date
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now() 
          : DateTime.now(),
    );
  }
}

// ✅ 2. Main User Model
class UserModel {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.profilePicture,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Smart helper to find phone number regardless of nesting
    String? extractPhone() {
      if (json['phone_number'] != null) return json['phone_number'];
      if (json['profile'] != null && json['profile'] is Map && json['profile']['phone_number'] != null) {
        return json['profile']['phone_number'];
      }
      return null;
    }

    return UserModel(
      id: json['id'] is int ? json['id'] : 0, // Prevent crash if ID is missing
      username: json['username'] ?? "Unknown",
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: extractPhone(),
      profilePicture: json['profile_picture'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
    };
  }

  String get displayName {
    if (firstName != null && firstName!.isNotEmpty) {
      if (lastName != null && lastName!.isNotEmpty) {
        return '$firstName $lastName';
      }
      return firstName!;
    }
    return username;
  }
}

// ✅ 3. User Profile Model (MERGED)
class UserProfileModel {
  final UserModel user;
  final String? profilePicture;
  final String? phoneNumber;
  final String? bio;
  final double rating;
  final String? role;
  
  // ✅ Fields for Profile & Trip Cards
  final DateTime createdAt;
  final String? vehiclePlateNumber;
  final String? vehicleModel;
  final int? vehicleSeats;
  final String? vehiclePhoto;

  // ✅ NEW: The list of reviews
  final List<ReviewModel> reviews; 

  UserProfileModel({
    required this.user,
    this.profilePicture,
    this.phoneNumber,
    this.bio,
    this.rating = 5.0,
    this.role,
    required this.createdAt,
    this.vehiclePlateNumber,
    this.vehicleModel,
    this.vehicleSeats,
    this.vehiclePhoto,
    required this.reviews, 
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    // Check if 'user' key exists, otherwise try to use the root json if it looks like a user object
    final userJson = json['user'] != null && json['user'] is Map<String, dynamic> 
        ? json['user'] 
        : json; // Fallback to self if flattened

    return UserProfileModel(
      user: UserModel.fromJson(userJson),
      
      // Map keys safely (handle variations like 'avatar' vs 'profile_picture')
      profilePicture: json['profile_picture'] ?? json['avatar'], 
      phoneNumber: json['phone_number'] ?? json['phone'],
      
      bio: json['bio'],
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      role: json['role'],
      
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at']) ?? DateTime.now()
          : DateTime.now(),

      vehiclePlateNumber: json['vehicle_plate_number'],
      vehicleModel: json['vehicle_model'],
      vehicleSeats: json['vehicle_seats'] is int ? json['vehicle_seats'] : int.tryParse(json['vehicle_seats']?.toString() ?? ""),
      vehiclePhoto: json['vehicle_photo'],

      // ✅ Map the list of reviews safely
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => ReviewModel.fromJson(e))
          .toList() ?? [],
    );
  }

  // Use this getter for easier UI access
  String? get avatar => profilePicture; 
}