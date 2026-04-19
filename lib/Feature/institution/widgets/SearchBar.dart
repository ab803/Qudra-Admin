import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    Key? key,
    this.hintText = 'Search institutions',
    this.onChanged,
    this.onFilterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: AppColors.iconGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: AppTextStyles.fieldLabel.copyWith(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.description.copyWith(fontSize: 14),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          // Vertical Divider
          Container(
            width: 1,
            height: 24,
            color: AppColors.border,
          ),
          // Filter Button

        ],
      ),
    );
  }
}