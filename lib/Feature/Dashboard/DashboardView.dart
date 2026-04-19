import 'package:admin_qudra/Feature/Dashboard/widgets/DashboardHeader.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/pendingVerificationList.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/statCard.dart';
import 'package:flutter/material.dart';
import '../../core/Styles/AppColors.dart';
import '../../core/Styles/AppTextStyles.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/Drawer.dart'; // Adjust path if needed


class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Qudra Admin',
          style: AppTextStyles.appBarTitle,
        ),

      ),
      drawer: const QudraDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DashboardHeader(),
            SizedBox(height: 24),

            StatCard(
              icon: Icons.people_outline,
              badgeText: '+12%',
              value: '42.8k',
              label: 'TOTAL USERS',
            ),
            SizedBox(height: 16),

            StatCard(
              icon: Icons.account_balance_outlined,
              badgeText: 'Active',
              value: '842',
              label: 'TOTAL INSTITUTIONS',
            ),
            SizedBox(height: 16),

            PendingVerificationsList(),
            SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}