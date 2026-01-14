# subscriptions/views.py
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.utils import timezone
from datetime import timedelta
from .models import SubscriptionPlan, UserSubscription
from .serializers import SubscriptionPlanSerializer, UserSubscriptionSerializer

# 1. List all available plans (Anyone can see this)
@api_view(['GET'])
@permission_classes([AllowAny])
def get_plans(request):
    plans = SubscriptionPlan.objects.all()
    serializer = SubscriptionPlanSerializer(plans, many=True)
    return Response(serializer.data)

# 2. Get My Current Subscription Status
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_my_subscription(request):
    try:
        sub = request.user.subscription
        serializer = UserSubscriptionSerializer(sub)
        return Response(serializer.data)
    except UserSubscription.DoesNotExist:
        return Response({"message": "No active subscription", "is_valid": False})

# 3. Activate Subscription (Call this AFTER successful payment in Flutter)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def subscribe_user(request):
    plan_id = request.data.get('plan_id')
    
    try:
        plan = SubscriptionPlan.objects.get(id=plan_id)
    except SubscriptionPlan.DoesNotExist:
        return Response({"error": "Plan not found"}, status=404)

    # Create or Update the subscription
    sub, created = UserSubscription.objects.get_or_create(user=request.user)
    
    # Update plan details
    sub.plan = plan
    sub.start_date = timezone.now()
    sub.end_date = timezone.now() + timedelta(days=plan.duration_days)
    sub.is_active = True
    sub.save()

    return Response({
        "message": f"Successfully subscribed to {plan.name}",
        "expires_at": sub.end_date
    })