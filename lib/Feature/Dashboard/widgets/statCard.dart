import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class StatCard extends StatelessWidget {
  final IconData icon;
  final String badgeText;
  final String value;
  final String label;

  const StatCard({
    Key? key,
    required this.icon,
    required this.badgeText,
    required this.value,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.border.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText,
                  style: AppTextStyles.fieldLabel.copyWith(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            value,
            style: AppTextStyles.largeTitle.copyWith(fontSize: 32),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.fieldLabel.copyWith(fontSize: 10, color: AppColors.textLight, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}