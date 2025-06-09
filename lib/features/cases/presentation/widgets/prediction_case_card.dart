import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sugeye/app/routing/routes.dart'; // Your routes class
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_summary.dart';

class PredictionCaseCard extends StatelessWidget {
  final PredictionSummary prediction;
  final int index;

  const PredictionCaseCard({
    required this.prediction,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        // color: Colors.grey[150],
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            GoRouter.of(context).pushNamed(
              Routes.caseDetail,
              pathParameters: {'predictionId': prediction.id},
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Case Number Badge
                // Container(
                //   width: 40,
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: AppColors.angelBlue.withAlpha(12),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: Center(
                //     child: Text(
                //       '#${index + 1}',
                //       style: const TextStyle(
                //         color: AppColors.angelBlue,
                //         fontWeight: FontWeight.bold,
                //         fontSize: 14,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 16),
                // Fundus Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      prediction.imageURL,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
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
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.visibility,
                            color: Colors.grey,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Case Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.bleachedCedar,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat.yMMMd().add_jm().format(
                              prediction.created,
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.angelBlue.withAlpha(25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Case ID: ${prediction.id.substring(0, 8)}...',
                          style: const TextStyle(
                            // color: AppColors.angelBlue,
                            color: AppColors.veniceBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.gray,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
