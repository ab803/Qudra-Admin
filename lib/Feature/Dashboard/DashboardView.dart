import 'package:admin_qudra/Feature/Dashboard/viewModel/dashboard_cubit.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/DashboardHeader.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/Drawer.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/metric_data.dart';
import 'package:admin_qudra/Feature/Dashboard/widgets/statCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/Styles/AppColors.dart';
import '../../core/Styles/AppTextStyles.dart';
import '../../core/Utilities/getit.dart';

// ... your existing imports

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  // Helper: format large numbers → "10.0k", "1,200", etc.
  String _fmt(num value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k';
    }
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..loadStats(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
          title: const Text('Qudra Admin', style: AppTextStyles.appBarTitle),
        ),
        drawer: const QudraDrawer(),
        body: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            // ── Loading ──
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // ── Error ──
            if (state is DashboardError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(state.message),
                    TextButton(
                      onPressed: () =>
                          context.read<DashboardCubit>().loadStats(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // ── Loaded ──
            final s = (state as DashboardLoaded).stats;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  const SizedBox(height: 24),

                  // ── Users Card ──
                  StatCard(
                    icon: Icons.people_outline,
                    title: 'Users',
                    metrics: [
                      MetricData(value: _fmt(s.totalUsers),    label: 'TOTAL USERS'),
                      MetricData(value: _fmt(s.subscribedUsers), label: 'SUBSCRIBERS'),
                      MetricData(value: '${_fmt(s.usersRevenue)} EGP', label: 'VALUE (EGP)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => context.go('/users'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Users Management'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Institutions Card ──
                  StatCard(
                    icon: Icons.account_balance_outlined,
                    title: 'Institutions',
                    metrics: [
                      MetricData(value: _fmt(s.totalInstitutions),      label: 'TOTAL'),
                      MetricData(value: _fmt(s.activeInstitutions),     label: 'ACTIVE'),
                      MetricData(value: _fmt(s.subscribedInstitutions), label: 'SUBSCRIBERS'),
                      MetricData(value: '${_fmt(s.institutionsRevenue)} EGP', label: 'VALUE (EGP)'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => context.go('/institutions'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Institutions Management'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}