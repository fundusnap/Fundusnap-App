// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:sugeye/app/routing/routes.dart';
// import 'package:sugeye/app/themes/app_colors.dart';
// import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
// import 'package:sugeye/features/prediction/domain/entities/prediction_tag.dart';
// import 'package:sugeye/features/prediction/presentation/widgets/summary_row.dart';

// class ResultScreen extends StatelessWidget {
//   final Prediction prediction;

//   const ResultScreen({super.key, required this.prediction});

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('Result screen image URL: ${prediction.imageURL}');
//     debugPrint('Image URL domain: ${Uri.parse(prediction.imageURL).host}');
//     // ? prediction with the highest probability
//     final PredictionTag topPrediction = prediction.predictions.reduce(
//       (current, next) =>
//           current.probability > next.probability ? current : next,
//     );

//     // ? helper to get a descriptive text based on the top prediction tag
//     String getResultDescription(String tagName) {
//       // TODO : DYNAMIC messages
//       switch (tagName) {
//         case "No DR":
//           return "Pemindaian AI tidak mendeteksi tanda-tanda signifikan dari retinopati diabetik pada gambar retina yang diberikan. Pemeriksaan mata rutin tetap disarankan.";
//         default:
//           return "Pemindaian AI mendeteksi tanda-tanda yang dapat menunjukkan $tagName. Sangat disarankan untuk menjadwalkan pemeriksaan lanjutan dengan dokter mata untuk diagnosis yang pasti.";
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Hasil Pemindaian')),
//       body: ListView(
//         padding: const EdgeInsets.all(20.0),
//         children: <Widget>[
//           // ? --- Main Result Heading ---
//           Text(
//             topPrediction.tagName,
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: AppColors.bleachedCedar,
//             ),
//           ),
//           const Gap(12),
//           // ?  --- Result Description ---
//           Text(
//             getResultDescription(topPrediction.tagName),
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//               color: AppColors.bleachedCedar,
//               height: 1.5,
//             ),
//           ),
//           const Gap(24),
//           //  ? --- Scanned Image Preview ---
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12.0),
//             child: Image.network(
//               prediction.imageURL,
//               fit: BoxFit.cover,
//               // ? Show a loading indicator while the image is loading from the network
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress == null) return child;
//                 return Center(
//                   child: CircularProgressIndicator(
//                     value: loadingProgress.expectedTotalBytes != null
//                         ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                         : null,
//                   ),
//                 );
//               },
//               errorBuilder: (context, error, stackTrace) {
//                 // Add detailed error logging
//                 debugPrint(
//                   '❌ Failed to load image in ResultScreen: ${prediction.imageURL}',
//                 );
//                 debugPrint('❌ Error: $error');
//                 debugPrint('❌ StackTrace: $stackTrace');
//                 return const Center(
//                   child: Icon(
//                     Icons.error_outline,
//                     color: AppColors.paleCarmine,
//                     size: 48,
//                   ),
//                 );
//               },
//             ),
//           ),
//           const Gap(24),
//           // ? --- Summary Section ---
//           Text(
//             'Ringkasan',
//             style: Theme.of(
//               context,
//             ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//           ),
//           const Gap(8),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Column(
//               children: [
//                 SummaryRow(
//                   label: 'Scan Date',
//                   value: DateFormat.yMMMMd().format(
//                     prediction.created,
//                   ), // ?  e.g., June 8, 2025
//                 ),
//                 const Divider(),
//                 const SummaryRow(
//                   label: 'AI Model',
//                   value: 'RetinaScan v1.2', //  ? Placeholder
//                 ),
//                 const Divider(),
//                 SummaryRow(
//                   label: 'Tingkat Keyakinan',
//                   value:
//                       '${(topPrediction.probability * 100).toStringAsFixed(0)}%',
//                   valueColor: AppColors.veniceBlue,
//                 ),
//               ],
//             ),
//           ),
//           const Gap(32),
//           // ? --- Action Buttons ---
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.veniceBlue,
//               foregroundColor: AppColors.white,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               textStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             onPressed: () {
//               GoRouter.of(context).pushNamed(
//                 Routes.chat,
//                 extra: <String, dynamic>{'predictionId': prediction.id},
//               );
//               // ).pushNamed(Routes.chat, extra: {'predictionId': prediction.id});
//             },
//             child: const Text('Tanya FundusAI'),
//           ),
//           const Gap(12),
//           TextButton(
//             onPressed: () {
//               GoRouter.of(context).goNamed(Routes.home);
//             },
//             child: const Text(
//               // ? 'Schedule Follow-up',
//               'Kembali ke Beranda',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.veniceBlue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_tag.dart';
import 'package:sugeye/features/prediction/presentation/widgets/summary_row.dart';

class ResultScreen extends StatefulWidget {
  final Prediction prediction;

  const ResultScreen({super.key, required this.prediction});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool showDetections = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('Result screen image URL: ${widget.prediction.imageURL}');
    debugPrint(
      'Image URL domain: ${Uri.parse(widget.prediction.imageURL).host}',
    );
    // ? prediction with the highest probability
    final PredictionTag topPrediction = widget.prediction.predictions.reduce(
      (current, next) =>
          current.probability > next.probability ? current : next,
    );

    // ? helper to get a descriptive text based on the top prediction tag
    String getResultDescription(String tagName) {
      // TODO : DYNAMIC messages
      switch (tagName) {
        case "No DR":
          return "Pemindaian AI tidak mendeteksi tanda-tanda signifikan dari retinopati diabetik pada gambar retina yang diberikan. Pemeriksaan mata rutin tetap disarankan.";
        default:
          return "Pemindaian AI mendeteksi tanda-tanda yang dapat menunjukkan $tagName. Sangat disarankan untuk menjadwalkan pemeriksaan lanjutan dengan dokter mata untuk diagnosis yang pasti.";
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Pemindaian')),
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
              showDetections
                  ? widget.prediction.detectionURL
                  : widget.prediction.imageURL,
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
                  '❌ Failed to load image in ResultScreen: ${widget.prediction.imageURL}',
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
          const Gap(12),
          Center(
            child: ToggleButtons(
              isSelected: [!showDetections, showDetections],
              onPressed: (index) {
                setState(() {
                  showDetections = index == 1;
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: AppColors.veniceBlue,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Original'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Deteksi'),
                ),
              ],
            ),
          ),
          const Gap(24),
          // ? --- Summary Section ---
          Text(
            'Ringkasan',
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
                SummaryRow(
                  label: 'Scan Date',
                  value: DateFormat.yMMMMd().format(
                    widget.prediction.created,
                  ), // ?  e.g., June 8, 2025
                ),
                const Divider(),
                const SummaryRow(
                  label: 'AI Model',
                  value: 'RetinaScan v1.2', //  ? Placeholder
                ),
                const Divider(),
                SummaryRow(
                  label: 'Tingkat Keyakinan',
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
              GoRouter.of(context).pushNamed(
                Routes.chat,
                extra: <String, dynamic>{'predictionId': widget.prediction.id},
              );
            },
            child: const Text('Tanya FundusAI'),
          ),
          const Gap(12),
          TextButton(
            onPressed: () {
              GoRouter.of(context).goNamed(Routes.home);
            },
            child: const Text(
              'Kembali ke Beranda',
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
