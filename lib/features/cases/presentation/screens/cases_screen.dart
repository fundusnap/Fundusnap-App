import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/cases/presentation/widgets/prediction_case_card.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PredictionListCubit>().fetchPredictions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PredictionListCubit, PredictionListState>(
      builder: (context, state) {
        if (state is PredictionListLoading || state is PredictionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PredictionListError) {
          return _buildErrorState(state);
        }

        if (state is PredictionListLoaded) {
          return _buildLoadedState(state);
        }

        return const Center(child: Text('Something went wrong.'));
      },
    );
  }

  Widget _buildErrorState(PredictionListError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.gray),
          const SizedBox(height: 16),
          Text(
            'Unable to load cases',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.gray),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<PredictionListCubit>().fetchPredictions();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(PredictionListLoaded state) {
    if (state.predictions.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Statistics Header
        _buildStatsHeader(state.predictions),

        // Filter/Sort Bar
        _buildFilterBar(),
        // Cases List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<PredictionListCubit>().fetchPredictions(),
            child: ListView.builder(
              itemCount: state.predictions.length,
              itemBuilder: (context, index) {
                final prediction = state.predictions[index];
                return PredictionCaseCard(prediction: prediction, index: index);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 96, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            'No Cases Yet',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            'Start scanning fundus images to build your case history',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to scan screen
              GoRouter.of(context).pushNamed(Routes.scan);
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Start Scanning'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(List<PredictionSummary> predictions) {
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
                child: _buildStatCard(
                  'Today',
                  todayCount.toString(),
                  Icons.today,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'This Week',
                  weekCount.toString(),
                  Icons.date_range,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total',
                  predictions.length.toString(),
                  Icons.folder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withAlpha(50)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: AppColors.gray, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Recent Cases',
            style: TextStyle(
              color: AppColors.veniceBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              // TODO: Implement sort options
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sort options coming soon')),
              );
            },
            child: const Row(
              children: [
                Text(
                  'Sort',
                  style: TextStyle(
                    color: AppColors.veniceBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.sort, color: AppColors.angelBlue, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
