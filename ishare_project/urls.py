from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),

    # ✅ THIS IS THE FIX:
    # We send ALL traffic starting with 'api/' to your api/urls.py file.
    # Since api/urls.py already has 'auth/token/', the result will be:
    # domain.com/api/auth/token/ (Exactly what Flutter wants!)
    path('api/', include('api.urls')),
]

# Allow media files (photos) to load during development/debug mode
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)