import logging
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.conf import settings
from .models import UserProfile

logger = logging.getLogger(__name__)

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_user_profile(sender, instance, created, **kwargs):
    """
    Safely creates a UserProfile when a User is created.
    """
    if created:
        try:
            # Check if profile already exists to prevent crashes
            if not UserProfile.objects.filter(user=instance).exists():
                UserProfile.objects.create(user=instance, role='passenger') # Default to passenger
                print(f"✅ Profile created for {instance.username}")
        except Exception as e:
            print(f"❌ CORE SIGNAL ERROR: Could not create profile: {e}")
            logger.error(f"Profile creation failed: {e}")

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def save_user_profile(sender, instance, **kwargs):
    """
    Safely saves the profile when the user is saved.
    """
    try:
        if hasattr(instance, 'profile'):
            instance.profile.save()
    except Exception as e:
        # Ignore errors here to prevent Admin crashes
        pass