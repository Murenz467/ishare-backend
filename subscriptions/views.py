from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.utils import timezone
from datetime import timedelta
from .models import SubscriptionPlan, UserSubscription
from .serializers import SubscriptionPlanSerializer, UserSubscriptionSerializer

# 1. List all available plans
@api_view(['GET'])
@permission_classes([AllowAny])
def get_plans(request):
    plans = SubscriptionPlan.objects.all()
    serializer = SubscriptionPlanSerializer(plans, many=True)
    return Response(serializer.data)

# 2. Get My Current Subscription Status (FIXED TO STOP CRASHING)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_my_subscription(request):
    # Use filter().first() instead of request.user.subscription
    # This returns None instead of crashing if no subscription exists
    sub = UserSubscription.objects.filter(user=request.user).first()
    
    if sub:
        serializer = UserSubscriptionSerializer(sub)
        return Response(serializer.data)
    else:
        return Response({"message": "No active subscription", "is_valid": False})

# 3. Activate Subscription
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