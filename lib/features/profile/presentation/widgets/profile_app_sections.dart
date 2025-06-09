import 'package:flutter/material.dart';
import 'package:sugeye/features/profile/presentation/widgets/profile_menu_section.dart';

class ProfileAppSection extends StatelessWidget {
  const ProfileAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileMenuSection(
      title: 'Application',
      items: [
        ProfileMenuItem(
          icon: Icons.palette_outlined,
          title: 'Theme',
          subtitle: 'Dark mode and appearance',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'Choose your language',
          onTap: null, // TODO: Implement
        ),
        ProfileMenuItem(
          icon: Icons.storage_outlined,
          title: 'Storage',
          subtitle: 'Manage local data and cache',
          onTap: null, // TODO: Implement
        ),
      ],
    );
  }
}
