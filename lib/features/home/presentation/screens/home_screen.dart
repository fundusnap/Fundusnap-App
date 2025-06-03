import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/home/presentation/widgets/recent_scan.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return
    //  Padding(
    // padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20, right: 20),
    // child:
    ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Text(
          "Welcome, Dr. Mike Jager",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(24),
        Text(
          "Start by scanning a patient's eyes to detect diabetic retinopathy. Follow the on-screen instructions for accurate results.",
          style: theme.textTheme.bodyLarge?.copyWith(),
        ),
        const Gap(16),
        ElevatedButton(
          onPressed: () {
            final int scanIndex = destinations.indexWhere(
              (d) => d.label == "Scan",
            );
            if (scanIndex != -1) {
              final StatefulNavigationShellState shell =
                  StatefulNavigationShell.of(context);
              shell.goBranch(scanIndex);
            } else {
              print(
                "Error: 'Scan' destination index not found. Navigating with goNamed as fallback.",
              );
            }
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.angelBlue),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: (Text(
              "Start Scan",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.bleachedCedar,
                fontWeight: FontWeight.bold,
              ),
            )),
          ),
        ),
        const Gap(16),
        Text(
          "Recent Scans",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              RecentScan(
                imagePath: "assets/images/eye_row.png",
                patientName: "Liam Harper",
                scanDate: DateTime(2025, 5, 26),
              ),
              const Gap(12),
              RecentScan(
                imagePath: "assets/images/eye_row_alt.png",
                patientName: "Olivia Bennet",
                scanDate: DateTime(2025, 5, 11),
              ),
              const Gap(12),
              RecentScan(
                imagePath: "assets/images/eye_row.png",
                patientName: "John Smith",
                scanDate: DateTime(2025, 5, 9),
              ),
              const Gap(8),
              RecentScan(
                imagePath: "assets/images/eye_row_alt.png",
                patientName: "Steven G.",
                scanDate: DateTime(2025, 4, 30),
              ),
            ],
          ),
        ),
        const Gap(16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Did You Know?",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.veniceBlue,
                  ),
                ),
                const Gap(8),
                Text(
                  "Regular eye check-ups are crucial for early detection of diabetic retinopathy, especially if you have diabetes. Encourage your patients to maintain a healthy lifestyle.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
    // );
  }
}
