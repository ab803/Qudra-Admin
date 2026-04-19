import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System\nStatus',
          style: AppTextStyles.largeTitle.copyWith(height: 1.1),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Real-time platform oversight and operational analytics.',
                style: AppTextStyles.description,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.border.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Export\nLogs',
                textAlign: TextAlign.center,
                style: AppTextStyles.fieldLabel.copyWith(fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                '+ New\n  Pro...',
                textAlign: TextAlign.center,
                style: AppTextStyles.button.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}