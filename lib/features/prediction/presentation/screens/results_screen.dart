import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_tag.dart';

class ResultScreen extends StatelessWidget {
  final Prediction prediction;

  const ResultScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    debugPrint('📸 Result screen image URL: ${prediction.imageURL}');
    debugPrint('📸 Image URL domain: ${Uri.parse(prediction.imageURL).host}');
    // ? prediction with the highest probability
    final PredictionTag topPrediction = prediction.predictions.reduce(
      (current, next) =>
          current.probability > next.probability ? current : next,
    );

    // ? helper to get a descriptive text based on the top prediction tag
    String getResultDescription(String tagName) {
      // TODO : DYNAMIC messages
      switch (tagName) {
        case "No DR":
          return "The AI scan did not detect any significant signs of diabetic retinopathy in the provided retinal image. Regular eye check-ups are still recommended.";
        default:
          return "The AI scan detected signs of what could be $tagName. It is highly recommended to schedule a follow-up with an ophthalmologist for a definitive diagnosis.";
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Results')),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          // ? --- Main Result Heading ---
          Text(
            topPrediction.tagName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.bleachedCedar,
            ),
          ),
          const Gap(12),
          // ?  --- Result Description ---
          Text(
            getResultDescription(topPrediction.tagName),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.bleachedCedar,
              height: 1.5,
            ),
          ),
          const Gap(24),
          //  ? --- Scanned Image Preview ---
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              prediction.imageURL,
              fit: BoxFit.cover,
              // ? Show a loading indicator while the image is loading from the network
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Add detailed error logging
                debugPrint(
                  '❌ Failed to load image in ResultScreen: ${prediction.imageURL}',
                );
                debugPrint('❌ Error: $error');
                debugPrint('❌ StackTrace: $stackTrace');
                return const Center(
                  child: Icon(
                    Icons.error_outline,
                    color: AppColors.paleCarmine,
                    size: 48,
                  ),
                );
              },
            ),
          ),
          const Gap(24),
          // ? --- Summary Section ---
          Text(
            'Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _SummaryRow(
                  label: 'Scan Date',
                  value: DateFormat.yMMMMd().format(
                    prediction.created,
                  ), // ?  e.g., June 8, 2025
                ),
                const Divider(),
                const _SummaryRow(
                  label: 'AI Model',
                  value: 'RetinaScan v1.2', //  ? Placeholder
                ),
                const Divider(),
                _SummaryRow(
                  label: 'Confidence',
                  value:
                      '${(topPrediction.probability * 100).toStringAsFixed(0)}%',
                  valueColor: AppColors.veniceBlue,
                ),
              ],
            ),
          ),
          const Gap(32),
          // ? --- Action Buttons ---
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.veniceBlue,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              // TODO: Implement navigation to chatbot
            },
            child: const Text('Ask FundusAI'),
          ),
          const Gap(12),
          TextButton(
            onPressed: () {
              // TODO: Implement scheduling logic or navigation
              GoRouter.of(context).goNamed(Routes.home);
            },
            child: const Text(
              // ? 'Schedule Follow-up',
              'Go Back to Home',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.veniceBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ? Helper widget for a row in the summary card
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.bleachedCedar,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
