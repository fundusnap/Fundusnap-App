import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';

class ProfileActionButtons extends StatelessWidget {
  final AppUser user;

  const ProfileActionButtons({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign Out Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showSignOutDialog(context),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.paleCarmine,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Version info
        Text(
          'FundusEye v1.0.0',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.paleCarmine,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
