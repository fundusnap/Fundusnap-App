import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class FundusAiLoadingState extends StatelessWidget {
  const FundusAiLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with loading animation
        Container(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 24), // Fixed padding
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.angelBlue, AppColors.veniceBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const CircularProgressIndicator(color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Memuat Riwayat Chat FundusAI...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Loading skeleton
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
