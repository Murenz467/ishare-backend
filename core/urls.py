from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import (
    register_user,
    TripViewSet,
    BookingViewSet,
    UserProfileViewSet,
    driver_verification_status,
    verify_driver,
    submit_rating
)

router = DefaultRouter()
router.register(r'trips', TripViewSet)
router.register(r'bookings', BookingViewSet)
router.register(r'profiles', UserProfileViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('register/', register_user, name='register'),
    path('auth/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('driver/verify/', verify_driver, name='verify_driver'),
    path('driver/verification-status/', driver_verification_status, name='driver_verification_status'),
    path('ratings/', submit_rating, name='submit_rating'),
]