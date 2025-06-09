import 'package:flutter/material.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_menu_section.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileMenuSection(
      title: 'Account',
      items: [
        ProfileMenuItem(
          icon: Icons.person_outline,
          title: 'Personal Information',
          subtitle: 'Update your profile details',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.security,
          title: 'Security',
          subtitle: 'Password and authentication',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          onTap: null, // TODO: Implement
        ),
      ],
    );
  }
}
