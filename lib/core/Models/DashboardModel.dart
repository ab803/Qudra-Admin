// lib/Feature/Dashboard/data/models/dashboard_stats_model.dart

class DashboardStatsModel {
  final int totalUsers;
  final int subscribedUsers;
  final double usersRevenue;

  final int totalInstitutions;
  final int activeInstitutions;
  final int subscribedInstitutions;
  final double institutionsRevenue;

  const DashboardStatsModel({
    required this.totalUsers,
    required this.subscribedUsers,
    required this.usersRevenue,
    required this.totalInstitutions,
    required this.activeInstitutions,
    required this.subscribedInstitutions,
    required this.institutionsRevenue,
  });

  factory DashboardStatsModel.empty() => const DashboardStatsModel(
    totalUsers: 0,
    subscribedUsers: 0,
    usersRevenue: 0,
    totalInstitutions: 0,
    activeInstitutions: 0,
    subscribedInstitutions: 0,
    institutionsRevenue: 0,
  );
}