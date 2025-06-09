import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';

class ProfileHeader extends StatelessWidget {
  final AppUser user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.angelBlue, AppColors.veniceBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.angelBlue.withAlpha(75),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withAlpha(100), width: 2),
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),

          const SizedBox(width: 20),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _extractDisplayName(user.email),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Medical Professional',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Settings button
          IconButton(
            onPressed: () {
              // TODO: Navigate to profile settings
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withAlpha(25),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
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
}
