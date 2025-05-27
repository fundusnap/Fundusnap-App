import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class GuideRow extends StatelessWidget {
  const GuideRow({required this.icon, required this.text, super.key});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.veniceBlue),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.bleachedCedar,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
