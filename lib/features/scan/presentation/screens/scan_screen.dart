import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/routing/routes.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/scan/presentation/widgets/guide_row.dart';
import 'package:sugeye/features/scan/presentation/widgets/scan_option_button.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Gap(25),
        const Text(
          'Retina Scan Options',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.veniceBlue,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'To detect Diabetic Retinopathy, you can either capture a new image of the fundus or upload an existing one.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.bleachedCedar.withAlpha(204),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),
        ScanOptionButton(
          icon: Icons.camera_alt_outlined,
          label: 'Capture New Image',
          backgroundColor: AppColors.veniceBlue,
          textColor: AppColors.white,
          onPressed: () {
            GoRouter.of(context).pushNamed(Routes.camera);
          },
        ),
        const SizedBox(height: 20),
        ScanOptionButton(
          icon: Icons.upload_file_outlined,
          label: 'Upload Existing Image',
          backgroundColor: AppColors.angelBlue,
          textColor: AppColors.bleachedCedar,
          onPressed: () {
            GoRouter.of(context).pushNamed(Routes.upload);
          },
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.angelBlue.withAlpha(50),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: AppColors.angelBlue.withAlpha(75)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Guide:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.veniceBlue,
                ),
              ),
              SizedBox(height: 8),
              GuideRow(
                icon: Icons.remove_red_eye_outlined,
                text:
                    'Ensure the special lens is correctly attached to your smartphone.',
              ),
              SizedBox(height: 6),
              GuideRow(
                icon: Icons.lightbulb_outline,
                text: 'Find a dimly lit room for better image quality.',
              ),
              SizedBox(height: 6),
              GuideRow(
                icon: Icons.center_focus_strong_outlined,
                text: 'Try to keep the eye steady and focused during capture.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
