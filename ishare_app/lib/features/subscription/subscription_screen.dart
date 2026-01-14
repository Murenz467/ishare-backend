import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../constants/app_theme.dart';
import 'package:ishare_app/screens/home/payment_screen.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isLoading = true;
  List<dynamic> _plans = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final api = ref.read(apiServiceProvider);
      final data = await api.fetchSubscriptionPlans();
      setState(() {
        _plans = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Helper to format currency
  String formatRWF(dynamic amount) {
    double value = double.tryParse(amount.toString()) ?? 0.0;
    return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // 🚀 THE MAIN LOGIC
  void _onPlanSelected(Map<String, dynamic> plan) async {
    // 1. Navigate to Payment Screen
    // We pass bookingId: -1 to signal this is a SUBSCRIPTION
    final paymentSuccess = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          totalAmount: double.parse(plan['price'].toString()),
          bookingId: -1, 
        ),
      ),
    );

    // 2. If they clicked "I have Paid"
    if (paymentSuccess == true) {
      _activateSubscription(plan['id']);
    }
  }

  Future<void> _activateSubscription(int planId) async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final api = ref.read(apiServiceProvider);
      await api.activateSubscription(planId);

      if (mounted) {
        Navigator.pop(context); // Close loader
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Welcome to Premium! Subscription Activated."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to Home
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loader
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Activation failed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Premium Plans", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _plans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final plan = _plans[index];
                    return _buildPlanCard(plan);
                  },
                ),
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.3), 
          width: 1
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan['name'], 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  "${plan['duration_days']} Days", 
                  style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.bold)
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "${formatRWF(plan['price'])} RWF", 
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.textDark)
          ),
          const SizedBox(height: 10),
          Text(
            plan['description'] ?? "Unlock premium features.",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onPlanSelected(plan),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 15)
              ),
              child: const Text("Choose Plan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}