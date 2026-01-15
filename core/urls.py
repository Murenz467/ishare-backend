from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    RegisterViewSet, CustomTokenObtainPairView, 
    TripViewSet, BookingViewSet, RatingViewSet, UserProfileViewSet,
    PaymentViewSet, 
    submit_driver_verification, check_verification_status,
    ForgotPasswordView, ResetPasswordView
)

# 1. Automatic Router
router = DefaultRouter()
router.register(r'trips', TripViewSet, basename='trip')
router.register(r'bookings', BookingViewSet, basename='booking')
router.register(r'profiles', UserProfileViewSet, basename='userprofile')
router.register(r'ratings', RatingViewSet, basename='rating')
router.register(r'payments', PaymentViewSet, basename='payments')

urlpatterns = [
    # 2. Router URLs
    path('', include(router.urls)),

    # 3. Auth URLs
    path('register/', RegisterViewSet.as_view({'post': 'create'}), name='register'),
    path('auth/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    path('auth/reset-password/', ResetPasswordView.as_view(), name='reset-password'),

    # 4. Driver Verification URLs (MATCHING FLUTTER EXACTLY)
    # ✅ Changed to 'verify/' to match your Flutter POST request
    path('driver/verify/', submit_driver_verification, name='submit-verification'),
    path('driver/verification-status/', check_verification_status, name='check-verification'),
]