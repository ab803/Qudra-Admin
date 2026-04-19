import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Models/institutionModel.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';

class InstitutionCard extends StatelessWidget {
  final Color logoColor;
  final InstitutionModel institution;
  final VoidCallback onDelete;

  const InstitutionCard({
    Key? key,
    required this.logoColor,
    required this.institution,
    required this.onDelete,
  }) : super(key: key);

  // 🔥 Status Color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'pending':
        return Colors.orange;
      case 'refused':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // 🔥 Status Text
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'pending':
        return 'Pending';
      case 'refused':
        return 'Refused';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(institution.status);
    final statusText = getStatusText(institution.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: logoColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.domain, color: AppColors.white),
              ),
              const SizedBox(width: 16),

              // 🔹 Name + Type
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      institution.name,
                      style: AppTextStyles.fieldLabel.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      institution.institutionType,
                      style: AppTextStyles.description.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),

              // 🔴 Delete
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent, size: 20),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // 🔹 Status + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // STATUS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: AppTextStyles.fieldLabel.copyWith(
                      fontSize: 10,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  context.go('/Service', extra: institution.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Services', style: AppTextStyles.button),
              ),

              // 🔵 View Button
              ElevatedButton(
                onPressed: () {
                  context.go('/institutionDetails', extra: institution);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text('View', style: AppTextStyles.button),
              ),
            ],
          ),
        ],
      ),
    );
  }
}