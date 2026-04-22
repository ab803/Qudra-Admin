import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final SupabaseClient _client;

  DashboardService(this._client);

  // ── Users ──────────────────────────────────────────────
  Future<int> fetchTotalUsers() async {
    final res = await _client
        .from('people_with_disability')
        .select('id');
    return res.length;
  }

  Future<Map<String, dynamic>> fetchBookingsStats() async {
    final res = await _client
        .from('bookings')
        .select('user_id, amount, payment_status');

    // ✅ Keep it as a List, NOT .length
    final successful = res.where(
          (b) => b['payment_status'] == 'success',
    ).toList();

    final total = successful.fold<double>(
      0,
          (sum, b) => sum + ((b['amount'] ?? 0) as num).toDouble(),
    );

    final uniqueSubscribedUsers = successful
        .map((b) => b['user_id'])
        .toSet()
        .length;

    return {
      'subscribedUsers': uniqueSubscribedUsers,
      'usersRevenue': total,
    };
  }

  // ── Institutions ───────────────────────────────────────
  Future<Map<String, dynamic>> fetchInstitutionsStats() async {
    final res = await _client
        .from('institutions')
        .select('id, status, subscribed');

    final active = res.where(
          (i) => i['status'] == 'active',
    ).length;

    final subscribed = res.where(
          (i) => i['subscribed'] == true,
    ).length;

    return {
      'total': res.length,
      'active': active,
      'subscribed': subscribed,
    };
  }

  Future<double> fetchInstitutionsRevenue() async {
    final res = await _client
        .from('subscription_institution')  // adjust if table name differs
        .select('Amount');

    return res.fold<double>(
      0,
          (sum, r) => sum + ((r['Amount'] ?? 0) as num).toDouble(),
    );
  }
}