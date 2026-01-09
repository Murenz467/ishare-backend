import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/app_theme.dart';
import '../../models/trip_model.dart';
import '../../services/api_service.dart';

class RateDriverDialog extends ConsumerStatefulWidget {
  final TripModel trip;

  const RateDriverDialog({super.key, required this.trip});

  @override
  ConsumerState<RateDriverDialog> createState() => _RateDriverDialogState();
}

class _RateDriverDialogState extends ConsumerState<RateDriverDialog> {
  double _rating = 5.0; // Default to 5 stars
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  // Professional Feedback Tags
  final List<String> _feedbackTags = [
    "Safe Driving",
    "Clean Car",
    "Good Music",
    "Friendly",
    "Punctual"
  ];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    final apiService = ref.read(apiServiceProvider);
    
    // Combine tags and comment
    String finalComment = _commentController.text;
    if (_selectedTags.isNotEmpty) {
      finalComment += "\n[Tags: ${_selectedTags.join(', ')}]";
    }

    try {
      // ✅ FIX: Explicitly send keys matching Django Serializer (trip_id, driver_id)
      // We pass a Map (JSON) instead of named arguments to ensure keys are correct
      await apiService.submitRating({
        'trip_id': widget.trip.id,          // 👈 This was missing/named wrong before
        'driver_id': widget.trip.driver.id,
        'rating': _rating,
        'comment': finalComment,
      });

      if (mounted) {
        Navigator.pop(context); // Close dialog
        
        // Success Message
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            content: const Text(
              "Rating Submitted!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close dialog on error too, or stay open?
        // Usually better to keep open so they can retry, but showing snackbar is good
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverName = widget.trip.driver.displayName.isNotEmpty 
        ? widget.trip.driver.displayName 
        : widget.trip.driver.username;

    // Safe Profile Picture Handling
    final String? driverPic = widget.trip.driver.profilePicture;
    
    // Helper for HTTPS
    String getValidUrl(String url) {
      if (url.startsWith('http')) {
        if (url.contains('127.0.0.1') || url.contains('localhost')) return url;
        return url.replaceFirst('http://', 'https://');
      }
      return url.startsWith('/') ? "http://127.0.0.1:8000$url" : "http://127.0.0.1:8000/$url";
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. DRIVER AVATAR
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: AppTheme.surfaceGrey,
                child: ClipOval(
                   child: SizedBox(
                     width: 70, height: 70,
                     child: (driverPic != null && driverPic.isNotEmpty)
                         ? Image.network(
                             getValidUrl(driverPic),
                             fit: BoxFit.cover,
                             errorBuilder: (c, e, s) => Center(child: Text(driverName[0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))),
                           )
                         : Center(child: Text(driverName[0].toUpperCase(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey))),
                   ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // 2. HEADER
            const Text("How was your ride?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.textDark)),
            Text("with $driverName", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            
            const SizedBox(height: 20),

            // 3. RATING BAR
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(Icons.star_rounded, color: Colors.amber, size: 40),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),

            const SizedBox(height: 20),

            // 4. FEEDBACK TAGS
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _feedbackTags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selected ? _selectedTags.add(tag) : _selectedTags.remove(tag);
                    });
                  },
                  backgroundColor: Colors.grey[100],
                  selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.primaryBlue : Colors.grey[700],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  checkmarkColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? AppTheme.primaryBlue : Colors.transparent)),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // 5. COMMENT BOX
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: "Add a note (optional)...",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 3,
              minLines: 2,
            ),

            const SizedBox(height: 24),

            // 6. BUTTONS
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Skip", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSubmitting 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Submit Rating", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}