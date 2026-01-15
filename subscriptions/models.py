from django.db import models
from django.conf import settings
from django.utils import timezone
from datetime import timedelta

class SubscriptionPlan(models.Model):
    name = models.CharField(max_length=100)       # e.g., "Monthly Pro"
    price = models.DecimalField(max_digits=10, decimal_places=2) # e.g., 5000.00
    duration_days = models.IntegerField()         # e.g., 30
    description = models.TextField(blank=True)    # e.g., "Access to all rides"
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.name} - {self.price} RWF"

class UserSubscription(models.Model):
    # ✅ We keep 'driver_subscription' to match your database structure
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, 
        on_delete=models.CASCADE, 
        related_name='driver_subscription'
    )
    plan = models.ForeignKey(SubscriptionPlan, on_delete=models.SET_NULL, null=True)
    start_date = models.DateTimeField(auto_now_add=True)
    end_date = models.DateTimeField()
    is_active = models.BooleanField(default=True)

    def save(self, *args, **kwargs):
        # Automatically set end_date if it's missing
        if not self.end_date and self.plan:
            self.end_date = timezone.now() + timedelta(days=self.plan.duration_days)
        super().save(*args, **kwargs)

    @property
    def is_valid(self):
        return self.is_active and self.end_date > timezone.now()

    def __str__(self):
        # ✅ CRITICAL FIX: 
        # We check if 'self.plan' exists. If it is None, we print "No Plan" instead of crashing.
        plan_name = self.plan.name if self.plan else "No Plan"
        return f"{self.user.username} - {plan_name}"