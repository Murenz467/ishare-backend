from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.contrib.auth.models import User
from .models import UserProfile, Trip, Booking, Rating, DriverVerification

# 1. Define the Profile Inline (Safe)
class UserProfileInline(admin.StackedInline):
    model = UserProfile
    can_delete = False
    verbose_name_plural = 'User Profile'
    fk_name = 'user'
    extra = 0  # Don't show empty extra rows

# 2. Define the Custom User Admin
class UserAdmin(BaseUserAdmin):
    inlines = (UserProfileInline,)
    list_display = ('username', 'email', 'get_role', 'is_active', 'date_joined')
    list_select_related = ('profile',) # Optimization

    def get_role(self, instance):
        # Safe access to role
        return instance.profile.role if hasattr(instance, 'profile') else 'No Profile'
    get_role.short_description = 'Role'

# 3. Register the new User Admin
# We safely unregister first to avoid "Already Registered" errors
try:
    admin.site.unregister(User)
except admin.sites.NotRegistered:
    pass
admin.site.register(User, UserAdmin)

# --- Other Models ---

@admin.register(Trip)
class TripAdmin(admin.ModelAdmin):
    list_display = ('id', 'driver_name', 'start_location_name', 'destination_name', 'departure_time', 'is_active')
    list_filter = ('is_active', 'departure_time')
    search_fields = ('start_location_name', 'destination_name')

    def driver_name(self, obj):
        return obj.driver.username if obj.driver else "Unknown"

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'passenger_name', 'trip_info', 'status', 'seats_booked')
    list_filter = ('status',)

    def passenger_name(self, obj):
        return obj.passenger.username if obj.passenger else "Unknown"
    
    def trip_info(self, obj):
        return f"Trip {obj.trip.id}" if obj.trip else "Unknown Trip"

@admin.register(DriverVerification)
class DriverVerificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'full_name', 'status', 'submitted_at')
    list_filter = ('status',)