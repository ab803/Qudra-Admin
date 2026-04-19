import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class ManagementHeader extends StatelessWidget {
  const ManagementHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MANAGEMENT CONSOLE',
          style: AppTextStyles.fieldLabel.copyWith(
            fontSize: 10,
            color: AppColors.textLight,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Institution\nManagement',
          style: AppTextStyles.largeTitle.copyWith(height: 1.1),
        ),
      ],
    );
  }
}