import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/cases/presentation/widgets/cases_stat_card.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';

class CasesStatsHeader extends StatelessWidget {
  final List<PredictionSummary> predictions;

  const CasesStatsHeader({super.key, required this.predictions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeek = now.subtract(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month, 1);

    final todayCount = predictions.where((p) {
      final predDate = DateTime(p.created.year, p.created.month, p.created.day);
      return predDate.isAtSameMomentAs(today);
    }).length;

    final weekCount = predictions
        .where((p) => p.created.isAfter(thisWeek))
        .length;

    final monthCount = predictions
        .where((p) => p.created.isAfter(thisMonth))
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.angelBlue, AppColors.veniceBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.angelBlue.withAlpha(75),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'Cases Overview',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CasesStatCard(
                  label: 'Today',
                  value: todayCount.toString(),
                  icon: Icons.today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CasesStatCard(
                  label: 'This Week',
                  value: weekCount.toString(),
                  icon: Icons.date_range,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CasesStatCard(
                  label: 'Total',
                  value: predictions.length.toString(),
                  icon: Icons.folder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
