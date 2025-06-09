import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sugeye/features/home/presentation/widgets/home_recent_scans_section.dart';
import 'package:sugeye/features/prediction/presentation/cubit/list/prediction_list_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch predictions when home screen loads
    context.read<PredictionListCubit>().fetchPredictions();
  }

  String _getWelcomeMessage(AuthState authState) {
    if (authState is AuthAuthenticated) {
      final displayName = _extractDisplayName(authState.user.email);
      return "Halo, Dr. $displayName";
    }
    return "Welcome, Doctor"; // Fallback for unauthenticated users
  }

  String _extractDisplayName(String email) {
    final name = email.split('@').first;
    return name
        .split('.')
        .map(
          (part) => part.isNotEmpty
              ? '${part[0].toUpperCase()}${part.substring(1)}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return ListView(
          children: [
            // ? welcome header
            Text(
              _getWelcomeMessage(authState),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),

            // ? description
            Text(
              "Mulai dengan memindai mata pasien untuk mendeteksi retinopati diabetik. Ikuti petunjuk di layar untuk hasil yang akurat.",
              style: theme.textTheme.bodyLarge,
            ),
            const Gap(16),

            // Start Scan Button
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.angelBlue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Mulai Pindai",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.bleachedCedar,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(24),

            // ? recent Scans Section
            const HomeRecentScansSection(),

            const Gap(24),

            // ? did you know card
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
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.veniceBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Apakah Anda Tahu?",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.veniceBlue,
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Text(
                      "Pemeriksaan mata rutin sangat penting untuk deteksi dini retinopati diabetik, terutama jika Anda menderita diabetes. Dorong pasien Anda untuk menjaga gaya hidup sehat.",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
