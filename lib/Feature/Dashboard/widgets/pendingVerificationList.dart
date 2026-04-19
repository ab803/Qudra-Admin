import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class PendingVerificationsList extends StatelessWidget {
  const PendingVerificationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pending Verifications', style: AppTextStyles.screenTitle.copyWith(fontSize: 18)),
              const Icon(Icons.arrow_outward, size: 20, color: AppColors.textPrimary),
            ],
          ),
          const SizedBox(height: 20),
          _buildVerificationItem('UM', 'University of Metropolis', 'Awaiting accreditation check', 'Priority'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: AppColors.border)),
          _buildVerificationItem('TC', 'Tech Collective Ltd', 'Document review pending', 'Standard'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider(height: 1, color: AppColors.border)),
          _buildVerificationItem('GH', 'Global Health Inc', 'KYC Update required', 'Standard'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: const Text('Review All (14)', style: AppTextStyles.button),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVerificationItem(String initials, String title, String subtitle, String badge) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
          alignment: Alignment.center,
          child: Text(initials, style: AppTextStyles.fieldLabel),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.fieldLabel.copyWith(fontSize: 14)),
              Text(subtitle, style: AppTextStyles.description.copyWith(fontSize: 12)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badge, style: AppTextStyles.fieldLabel.copyWith(fontSize: 10)),
        ),
      ],
    );
  }
}