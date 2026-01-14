# subscriptions/serializers.py
from rest_framework import serializers
from .models import SubscriptionPlan, UserSubscription

class SubscriptionPlanSerializer(serializers.ModelSerializer):
    class Meta:
        model = SubscriptionPlan
        fields = ['id', 'name', 'price', 'duration_days', 'description']

class UserSubscriptionSerializer(serializers.ModelSerializer):
    plan = SubscriptionPlanSerializer(read_only=True)
    is_valid = serializers.ReadOnlyField() # Sends 'true' or 'false' to Flutter
    
    class Meta:
        model = UserSubscription
        fields = ['plan', 'start_date', 'end_date', 'is_active', 'is_valid']