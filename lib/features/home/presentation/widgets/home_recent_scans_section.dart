import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';
// import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/home/presentation/widgets/recent_scan.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class HomeRecentScansSection extends StatelessWidget {
  const HomeRecentScansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pemindaian Terbaru",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to cases screen
                final int casesIndex = destinations.indexWhere(
                  (d) => d.label == "Cases",
                );
                if (casesIndex != -1) {
                  final StatefulNavigationShellState shell =
                      StatefulNavigationShell.of(context);
                  shell.goBranch(casesIndex);
                }
              },
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  color: AppColors.veniceBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),

        // Recent Scans List
        BlocBuilder<PredictionListCubit, PredictionListState>(
          builder: (context, state) {
            if (state is PredictionListLoading ||
                state is PredictionListInitial) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3, // Show 3 loading placeholders
                  itemBuilder: (context, index) {
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.angelBlue,
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            if (state is PredictionListError) {
              return Container(
                height: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey.shade400,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak dapat memuat pemindaian terbaru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          context
                              .read<PredictionListCubit>()
                              .fetchPredictions();
                        },
                        child: const Text(
                          'Coba Lagi',
                          style: TextStyle(color: AppColors.angelBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PredictionListLoaded) {
              if (state.predictions.isEmpty) {
                return Container(
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.angelBlue.withAlpha(12),
                        AppColors.veniceBlue.withAlpha(12),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.angelBlue.withAlpha(25),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          color: AppColors.angelBlue.withAlpha(150),
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada pemindaian',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.angelBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mulai pemindaian untuk melihat kasus terbaru di sini',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show recent scans (max 5)
              final recentScans = state.predictions.take(5).toList();

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentScans.length,
                  itemBuilder: (context, index) {
                    return RecentScan(
                      prediction: recentScans[index],
                      index: index,
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
