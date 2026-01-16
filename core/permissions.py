from rest_framework import permissions

class IsDriverOrReadOnly(permissions.BasePermission):
    """
    Custom permission to only allow Drivers to edit/create.
    Passengers can only view (GET).
    """

    def has_permission(self, request, view):
        # 1. Allow anyone to view (GET, HEAD, OPTIONS)
        if request.method in permissions.SAFE_METHODS:
            return True

        # 2. Check if user is authenticated
        if not request.user or not request.user.is_authenticated:
            return False

        # 3. Check if user is a Driver (Safety Check)
        if not hasattr(request.user, 'profile'):
            return False
            
        return request.user.profile.role == 'driver'

    def has_object_permission(self, request, view, obj):
        # 1. Allow anyone to view
        if request.method in permissions.SAFE_METHODS:
            return True

        # 2. Write permissions are only allowed to the author (the driver)
        return obj.driver == request.user