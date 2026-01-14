from django.db import models
from django.contrib.auth.models import User

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    bio = models.TextField(blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profile_pics/', blank=True, null=True)
    role = models.CharField(max_length=20, default='passenger')
    vehicle_model = models.CharField(max_length=50, blank=True, null=True)
    vehicle_plate_number = models.CharField(max_length=20, blank=True, null=True)
    vehicle_photo = models.ImageField(upload_to='vehicle_photos/', blank=True, null=True)
    is_verified = models.BooleanField(default=False)
    verification_status = models.CharField(max_length=20, default='none')

    def __str__(self):
        return self.user.username

class Trip(models.Model):
    driver = models.ForeignKey(User, on_delete=models.CASCADE)
    start_location = models.CharField(max_length=255)
    destination = models.CharField(max_length=255)
    date = models.DateField()
    time = models.TimeField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    available_seats = models.IntegerField()
    description = models.TextField(blank=True)
    status = models.CharField(max_length=20, default='scheduled')

    def __str__(self):
        return f"{self.start_location} to {self.destination}"

class Booking(models.Model):
    trip = models.ForeignKey(Trip, on_delete=models.CASCADE)
    passenger = models.ForeignKey(User, on_delete=models.CASCADE)
    seats_booked = models.IntegerField(default=1)
    status = models.CharField(max_length=20, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)

class Rating(models.Model):
    trip = models.ForeignKey(Trip, on_delete=models.CASCADE)
    rater = models.ForeignKey(User, on_delete=models.CASCADE, related_name='ratings_given')
    ratee = models.ForeignKey(User, on_delete=models.CASCADE, related_name='ratings_received')
    score = models.IntegerField()
    comment = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)