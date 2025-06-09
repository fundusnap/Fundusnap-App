import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_ai_header.dart';
import 'package:sugeye/features/fundus_ai/presentation/widgets/fundus_feature_card.dart';

class FundusAiEmptyState extends StatelessWidget {
  const FundusAiEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const FundusAiHeader(title: "FundusAI Assistant"),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.angelBlue.withAlpha(25),
                          AppColors.veniceBlue.withAlpha(25),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      size: 80,
                      color: AppColors.angelBlue,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'No Conversations Yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.angelBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start analyzing your retinal scans to begin conversations with FundusAI',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Feature highlights
                  const FeatureCard(
                    icon: Icons.visibility,
                    title: 'Analyze Scans',
                    description: 'Get AI insights on diabetic retinopathy',
                  ),
                  const SizedBox(height: 12),
                  const FeatureCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Ask Questions',
                    description: 'Chat about results and recommendations',
                  ),
                  const SizedBox(height: 12),
                  const FeatureCard(
                    icon: Icons.history,
                    title: 'View History',
                    description: 'Access all your previous conversations',
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
