import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/core/services/azure_prediction_service.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Image')),
      backgroundColor: AppColors.bleachedCedar,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Center(child: Image.file(File(widget.imagePath)))),
            const Gap(13),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Retake'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gray,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Use Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.veniceBlue,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () async {
                      // TODO: Implement what happens when the user confirms the photo.
                      // ? options:
                      // ? 1. Popping this screen and returning the imagePath to CameraScreen,
                      //  ?  which then navigates to UploadScreen.
                      // ? 2. Directly navigating to UploadScreen from here with the imagePath.
                      //  ?  e.g., GoRouter.of(context).pushNamed(Routes.upload, extra: imagePath);
                      //?  For now, let's print and pop all the way to scan screen (or where appropriate)
                      print('Image confirmed: ${widget.imagePath}. Attempting');

                      // Example: Navigate to upload screen (assuming it takes imagePath as argument)
                      // And remove camera and preview screens from stack.
                      // This depends on your GoRouter setup.
                      // A simple way for now is to pop until a certain route or pass data back.

                      // If UploadScreen needs to be pushed and CameraScreen + DisplayPictureScreen removed:
                      // GoRouter.of(context).pop(); // Pop DisplayPictureScreen
                      // GoRouter.of(context).pop(imagePath); // Pop CameraScreen, returning imagePath
                      // The ScanScreen (or whatever called CameraScreen) would then receive imagePath
                      // and navigate to UploadScreen.

                      // OR directly navigate to upload screen if it's simpler:
                      // Ensure Routes.upload is defined and can accept imagePath.
                      // This will push UploadScreen on top.
                      // context.pushNamed(Routes.upload, extra: imagePath);
                      final AzurePredictionService predictionService =
                          AzurePredictionService();
                      try {
                        final File imageFile = File(widget.imagePath);
                        final Map<String, dynamic>? predictionResult =
                            await predictionService.predictImage(imageFile);

                        if (predictionResult != null) {
                          print('-----------------------------------------');
                          print('✅ Azure Prediction Successful:');
                          print(predictionResult);
                          print('-----------------------------------------');
                          // TODO: Later, you will navigate to a new screen with this result.
                          // Example: GoRouter.of(context).pushNamed(Routes.results, extra: predictionResult);
                        } else {
                          print('❌ Azure Prediction Failed or returned null.');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Could not get prediction. Please try again.',
                                ),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        print('❌ Error during prediction call: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      } finally {
                        if (context.mounted) {
                          GoRouter.of(
                            context,
                          ).pop(widget.imagePath); // ? pop and return imagePath
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
