import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugeye/app/themes/app_colors.dart';
import 'package:sugeye/features/auth/domain/entities/app_user.dart';
import 'package:sugeye/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_account_section.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_app_sections.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_stats_section.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_support_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return ProfileLoadedView(user: state.user);
        }

        if (state is AuthLoading) {
          return const ProfileLoadingView();
        }

        if (state is AuthError) {
          return ProfileErrorView(message: state.message);
        }

        return const ProfileUnauthenticatedView();
      },
    );
  }
}

class ProfileLoadedView extends StatelessWidget {
  final AppUser user;

  const ProfileLoadedView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeader(user: user),

          const SizedBox(height: 24),

          // Stats Cards
          const ProfileStatsSection(),

          const SizedBox(height: 24),

          // Account Settings Section
          const ProfileAccountSection(),

          const SizedBox(height: 24),

          // App Settings Section
          const ProfileAppSection(),

          const SizedBox(height: 24),

          // Support Section
          const ProfileSupportSection(),

          const SizedBox(height: 32),

          // Action Buttons
          ProfileActionButtons(user: user),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header skeleton
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.angelBlue),
          ),
        ),

        // Content skeleton
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileErrorView extends StatelessWidget {
  final String message;

  const ProfileErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.paleCarmine.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.paleCarmine,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Profile Error',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.gray, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Retry loading profile
                context.read<AuthCubit>().signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.angelBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileUnauthenticatedView extends StatelessWidget {
  const ProfileUnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.angelBlue.withAlpha(25),
                    AppColors.veniceBlue.withAlpha(25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.person_outline,
                size: 80,
                color: AppColors.angelBlue,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Not Signed In',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.angelBlue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please sign in to access your profile and manage your account settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.gray,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
