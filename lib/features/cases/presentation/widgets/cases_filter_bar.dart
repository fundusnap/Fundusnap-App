import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';

class CasesFilterBar extends StatelessWidget {
  const CasesFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: AppColors.gray, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Kasus Terbaru',
            style: TextStyle(
              color: AppColors.veniceBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sort options coming soon')),
              );
            },
            child: const Row(
              children: [
                Text(
                  'Urutkan',
                  style: TextStyle(
                    color: AppColors.veniceBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.sort, color: AppColors.angelBlue, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
