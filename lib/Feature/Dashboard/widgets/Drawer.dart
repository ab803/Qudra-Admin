import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';


class QudraDrawer extends StatelessWidget {
  const QudraDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Text(
                'Qudra Admin',
                style: AppTextStyles.screenTitle,
              ),
            ),

            /// Dashboard
            _buildDrawerItem(
              context: context,
              icon: Icons.grid_view,
              title: 'Overview',
              isSelected:false ,
              onTap: () {
                context.go("/Dashboard");
              },
            ),

            _buildDrawerItem(
              context: context,
              icon: Icons.subscriptions,
              title: 'Bundles',
              isSelected:false ,
              onTap: () {
                context.go("/subscribtions");
              },
            ),

            /// Institutions
            _buildDrawerItem(
              context: context,
              icon: Icons.domain,
              title: 'Institution Management',
              isSelected: false,
              onTap: () {
                context.go("/institutions");
              },
            ),

            /// Placeholder
            _buildDrawerItem(
              context: context,
              icon: Icons.person,
              title: 'Users',
              isSelected: false,
              onTap: () {
                context.go("/users");
              },
            ),

            _buildDrawerItem(
              context: context,
              icon: Icons.tips_and_updates,
              title: 'Rights&tips',
              isSelected: false,
              onTap: () {
                context.go("/tips&rights");
              },
            ),



            const Spacer(),



          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isSelected,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isSelected ? AppColors.white : AppColors.iconGrey,
          ),
          title: Text(
            title,
            style: AppTextStyles.fieldLabel.copyWith(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildSupportButton(
      IconData icon, Color bgColor, Color iconColor) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }


}