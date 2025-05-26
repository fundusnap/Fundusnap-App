import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20, right: 20),
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Text(
            "Welcome, Dr Dredorus Drah",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(16),
          Text(
            "Start by scanning a patient's eyes to detect diabetic retinopathy. Follow the on-screen instructions for accurate results.",
            style: theme.textTheme.bodyLarge?.copyWith(),
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: () {},
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.angelBlue),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: (Text(
                "Start Scan",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.bleachedCedar,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
