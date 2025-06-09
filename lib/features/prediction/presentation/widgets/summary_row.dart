import 'package:flutter/material.dart';
import 'package:sugeye/app/themes/app_colors.dart';

// ? Helper widget for a row in the summary card
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.gray, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? AppColors.bleachedCedar,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
