import '../../../core/Models/DashboardModel.dart';
import '../../../core/Services/Supabase/DashboardService.dart';


class DashboardRepository {
  final DashboardService _service;

  DashboardRepository(this._service);

  Future<DashboardStatsModel> fetchStats() async {
    final results = await Future.wait([
      _service.fetchTotalUsers(),
      _service.fetchBookingsStats(),
      _service.fetchInstitutionsStats(),
      _service.fetchInstitutionsRevenue(),
    ]);

    final totalUsers           = results[0] as int;
    final bookingsStats        = results[1] as Map<String, dynamic>;
    final institutionsStats    = results[2] as Map<String, dynamic>;
    final institutionsRevenue  = results[3] as double;

    return DashboardStatsModel(
      totalUsers:              totalUsers,
      subscribedUsers:         bookingsStats['subscribedUsers'] as int,
      usersRevenue:            bookingsStats['usersRevenue'] as double,
      totalInstitutions:       institutionsStats['total'] as int,
      activeInstitutions:      institutionsStats['active'] as int,
      subscribedInstitutions:  institutionsStats['subscribed'] as int,
      institutionsRevenue:     institutionsRevenue,
    );
  }
}