from django.contrib import admin
from .models import SubscriptionPlan, UserSubscription, SubscriptionTransaction

@admin.register(SubscriptionPlan)
class SubscriptionPlanAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'duration_days', 'target_role')
    list_filter = ('target_role',)

@admin.register(UserSubscription)
class UserSubscriptionAdmin(admin.ModelAdmin):
    list_display = ('get_username', 'plan_name', 'start_date', 'end_date', 'is_active', 'is_valid')
    list_filter = ('is_active', 'plan')
    search_fields = ('user__username', 'user__email')

    def get_username(self, obj):
        return obj.user.username if obj.user else "Unknown User"
    get_username.short_description = "User"

    def plan_name(self, obj):
        return obj.plan.name if obj.plan else "No Plan"
    plan_name.short_description = "Plan"

@admin.register(SubscriptionTransaction)
class SubscriptionTransactionAdmin(admin.ModelAdmin):
    list_display = ('transaction_id', 'get_username', 'amount', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('transaction_id', 'user__username')

    def get_username(self, obj):
        return obj.user.username if obj.user else "Unknown User"
    get_username.short_description = "User"