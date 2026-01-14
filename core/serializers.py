from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Trip, Booking, UserProfile, Rating

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']

class UserProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    class Meta:
        model = UserProfile
        fields = '__all__'

class TripSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.username', read_only=True)
    class Meta:
        model = Trip
        fields = '__all__'

class BookingSerializer(serializers.ModelSerializer):
    trip_details = TripSerializer(source='trip', read_only=True)
    passenger_name = serializers.CharField(source='passenger.username', read_only=True)
    class Meta:
        model = Booking
        fields = '__all__'

class RatingSerializer(serializers.ModelSerializer):
    rater_name = serializers.CharField(source='rater.username', read_only=True)
    class Meta:
        model = Rating
        fields = '__all__'