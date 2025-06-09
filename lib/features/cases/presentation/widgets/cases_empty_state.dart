import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sugeye/app/layout/destinations.dart';
import 'package:sugeye/app/routing/routes.dart';

class CasesEmptyState extends StatelessWidget {
  const CasesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 96, color: Colors.grey.shade300),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Kasus',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            'Mulai scan gambar fundus untuk membangun riwayat kasus Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
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

              // GoRouter.of(context).pushNamed(Routes.scan);
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Mulai Scan'),
          ),
        ],
      ),
    );
  }
}
