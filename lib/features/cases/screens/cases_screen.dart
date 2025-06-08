import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sugeye/app/routing/routes.dart'; // Your routes class
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

// Convert to StatefulWidget to use initState
class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger the initial data fetch when the screen is first built.
    // We use context.read because we only need to call the method once, not listen.
    context.read<PredictionListCubit>().fetchPredictions();
  }

  @override
  Widget build(BuildContext context) {
    // The rest of the build method is the same, using BlocBuilder.
    return BlocBuilder<PredictionListCubit, PredictionListState>(
      builder: (context, state) {
        if (state is PredictionListLoading || state is PredictionListInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PredictionListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
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
        if (state is PredictionListLoaded) {
          if (state.predictions.isEmpty) {
            return const Center(
              child: Text(
                'No past cases found.',
                style: TextStyle(fontSize: 18, color: AppColors.gray),
              ),
            );
          }
          // Display the list of predictions with RefreshIndicator
          return RefreshIndicator(
            onRefresh: () =>
                context.read<PredictionListCubit>().fetchPredictions(),
            child: ListView.builder(
              itemCount: state.predictions.length,
              itemBuilder: (context, index) {
                final prediction = state.predictions[index];
                return _PredictionCaseCard(prediction: prediction);
              },
            ),
          );
        }
        return const Center(child: Text('Something went wrong.'));
      },
    );
  }
}

class _PredictionCaseCard extends StatelessWidget {
  final PredictionSummary prediction;
  const _PredictionCaseCard({required this.prediction});

  @override
  Widget build(BuildContext context) {
    debugPrint('📸 Case card image URL: ${prediction.imageURL}');
    debugPrint('📸 Image URL domain: ${Uri.parse(prediction.imageURL).host}');
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: Image.network(
              prediction.imageURL,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: AppColors.angelBlue,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ Failed to load image: ${prediction.imageURL}');
                debugPrint('❌ Error: $error');
                return Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.broken_image,
                    color: Colors.grey,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ),
        title: Text(
          prediction.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Scanned on ${DateFormat.yMMMd().format(prediction.created)}',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.gray),
        onTap: () {
          // Navigate to the detail screen, passing the ID in the path
          GoRouter.of(context).pushNamed(
            Routes.caseDetail,
            pathParameters: {'predictionId': prediction.id},
          );
        },
      ),
    );
  }
}
