import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  // If using GoRouter for this screen, define a route name
  // static const String routeName = 'display_picture'; // Example

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Image'),
        backgroundColor: AppColors.veniceBlue,
        foregroundColor: AppColors.white,
        // GoRouter might handle the back button automatically if this is part of its stack
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: AppColors.white),
        //   onPressed: () => Navigator.of(context).pop(),
        // ),
      ),
      backgroundColor: AppColors.bleachedCedar,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: Center(child: Image.file(File(imagePath)))),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                      // Just pop to go back to the CameraScreen
                      Navigator.of(context).pop();
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
                    onPressed: () {
                      // TODO: Implement what happens when the user confirms the photo.
                      // This could involve:
                      // 1. Popping this screen and returning the imagePath to CameraScreen,
                      //    which then navigates to UploadScreen.
                      // 2. Directly navigating to UploadScreen from here with the imagePath.
                      //    e.g., GoRouter.of(context).pushNamed(Routes.upload, extra: imagePath);
                      // For now, let's print and pop all the way to scan screen (or where appropriate)
                      print('Image confirmed: $imagePath');

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

                      // For demonstration, let's just pop this screen.
                      // You'll need to decide the exact navigation flow.
                      Navigator.of(
                        context,
                      ).pop(imagePath); // Pop and return imagePath
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
