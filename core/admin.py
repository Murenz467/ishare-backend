from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.models import User
from .models import (
    UserProfile, Trip, Booking, Rating, 
    PaymentTransaction, DriverVerification
)

# 1. User Profile Inline (Shows profile inside User screen)
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'Profile'

# 2. Extend User Admin
class CustomUserAdmin(UserAdmin):
    inlines = (UserProfileInline,)
    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'get_role')
    
    def get_role(self, instance):
        return instance.profile.role if hasattr(instance, 'profile') else 'None'
    get_role.short_description = 'Role'

# Re-register User
admin.site.unregister(User)
admin.site.register(User, CustomUserAdmin)

# 3. Trip Admin
@admin.register(Trip)
class TripAdmin(admin.ModelAdmin):
    list_display = ('id', 'driver', 'start_location_name', 'destination_name', 'price_per_seat', 'departure_time', 'is_active')
    list_filter = ('is_active', 'departure_time')
    search_fields = ('start_location_name', 'destination_name', 'driver__username')

# 4. Booking Admin
@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'passenger', 'trip', 'seats_booked', 'total_price', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('passenger__username', 'trip__destination_name')

# 5. Payment Admin
@admin.register(PaymentTransaction)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ('id', 'booking', 'amount', 'provider', 'status', 'created_at')
    list_filter = ('status', 'provider')

# 6. Driver Verification Admin (CRITICAL for approving drivers)
@admin.register(DriverVerification)
class DriverVerificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'full_name', 'national_id', 'status', 'submitted_at')
    list_filter = ('status',)
    actions = ['approve_verification', 'reject_verification']

    def approve_verification(self, request, queryset):
        queryset.update(status='approved')
    approve_verification.short_description = "Approve selected drivers"

    def reject_verification(self, request, queryset):
        queryset.update(status='rejected')

# 7. Rating Admin
admin.site.register(Rating)