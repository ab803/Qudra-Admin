import 'package:flutter/material.dart';
import '../../../core/Styles/AppTextStyles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System\nDashboard',
          style: AppTextStyles.largeTitle.copyWith(height: 1.1),
        ),
        const SizedBox(height: 8),
        Text(                                   // ✅ no Expanded needed
          'Real-time platform oversight and operational analytics.',
          style: AppTextStyles.description,
        ),
      ],
    );
  }
}