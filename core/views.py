from rest_framework import viewsets, status, permissions
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from django.contrib.auth.models import User
from .models import Trip, Booking, UserProfile, Rating
from .serializers import TripSerializer, BookingSerializer, UserProfileSerializer, RatingSerializer

@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def register_user(request):
    data = request.data
    try:
        user = User.objects.create_user(
            username=data['username'],
            email=data['email'],
            password=data['password'],
            first_name=data.get('first_name', ''),
            last_name=data.get('last_name', '')
        )
        UserProfile.objects.create(user=user, role=data.get('role', 'passenger'))
        return Response({'message': 'User created successfully'}, status=status.HTTP_201_CREATED)
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

class TripViewSet(viewsets.ModelViewSet):
    queryset = Trip.objects.all()
    serializer_class = TripSerializer

class BookingViewSet(viewsets.ModelViewSet):
    queryset = Booking.objects.all()
    serializer_class = BookingSerializer

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

@api_view(['GET'])
def driver_verification_status(request):
    return Response({'status': 'approved', 'is_verified': True})

@api_view(['POST'])
def verify_driver(request):
    return Response({'message': 'Verification submitted'})

@api_view(['POST'])
def submit_rating(request):
    return Response({'message': 'Rating submitted'})
