from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    RegisterViewSet, CustomTokenObtainPairView, 
    TripViewSet, BookingViewSet, RatingViewSet, UserProfileViewSet,
    PaymentViewSet, 
    submit_driver_verification, check_verification_status,
    ForgotPasswordView, ResetPasswordView
)

# 1. Automatic Router (Handles lists, details, create, update, delete)
router = DefaultRouter()
router.register(r'trips', TripViewSet)          # /api/trips/
router.register(r'bookings', BookingViewSet)    # /api/bookings/
router.register(r'profiles', UserProfileViewSet)# /api/profiles/
router.register(r'ratings', RatingViewSet)      # /api/ratings/
# Note: PaymentViewSet is a ViewSet but doesn't use a model queryset directly in standard way, 
# but using router is fine if we defined list/create methods (which we did).
router.register(r'payments', PaymentViewSet, basename='payments') 

urlpatterns = [
    # 2. Router URLs (The bulk of the API)
    path('', include(router.urls)),

    # 3. Auth URLs
    path('register/', RegisterViewSet.as_view({'post': 'create'}), name='register'), # /api/register/
    path('auth/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'), # /api/auth/token/
    
    # 4. Password Reset
    path('auth/forgot-password/', ForgotPasswordView.as_view(), name='forgot-password'),
    path('auth/reset-password/', ResetPasswordView.as_view(), name='reset-password'),

    # 5. Driver Verification URLs
    path('driver-verification/submit/', submit_driver_verification, name='submit-verification'),
    path('driver-verification/status/', check_verification_status, name='check-verification'),
]