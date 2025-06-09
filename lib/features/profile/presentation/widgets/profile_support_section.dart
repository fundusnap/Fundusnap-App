import 'package:flutter/material.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_menu_section.dart';

class ProfileSupportSection extends StatelessWidget {
  const ProfileSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileMenuSection(
      title: 'Support',
      items: [
        ProfileMenuItem(
          icon: Icons.help_outline,
          title: 'Help & FAQ',
          subtitle: 'Get help and find answers',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.contact_support_outlined,
          title: 'Contact Support',
          subtitle: 'Reach out to our team',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'App version and information',
          onTap: null, // TODO: Implement
        ),
      ],
    );
  }
}
