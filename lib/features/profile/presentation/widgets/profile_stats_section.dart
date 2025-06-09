import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_stats_card.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity Overview',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: ProfileStatsCard(
                icon: Icons.visibility,
                title: 'Scans',
                value: '24',
                subtitle: 'Total',
                color: AppColors.angelBlue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ProfileStatsCard(
                icon: Icons.chat_bubble_outline,
                title: 'Chats',
                value: '8',
                subtitle: 'Active',
                color: AppColors.veniceBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
