# subscriptions/urls.py
from django.urls import path
from . import views

urlpatterns = [
    # API: GET /api/subscriptions/plans/
    path('plans/', views.get_plans, name='get_plans'),
    
    # API: GET /api/subscriptions/my-subscription/
    path('my-subscription/', views.get_my_subscription, name='my_subscription'),
    
    # API: POST /api/subscriptions/subscribe/
    path('subscribe/', views.subscribe_user, name='subscribe_user'),
]