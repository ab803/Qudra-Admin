import 'package:supabase_flutter/supabase_flutter.dart';

class InstitutionService {
  final SupabaseClient _supabaseClient;
  final String _tableName = 'institutions';

  InstitutionService(this._supabaseClient);
  // Fetch Data
  Future<List<dynamic>> fetchInstitutions() async {
    return await _supabaseClient
        .from(_tableName)
        .select()
        .order('created_at', ascending: false);
  }
  // insert Data
  Future<void> createInstitution(Map<String, dynamic> institutionData) async {
    await _supabaseClient.from(_tableName).insert(institutionData);
  }
  // Ubdate Data
  Future<void> updateInstitution(String id, Map<String, dynamic> institutionData) async {
    await _supabaseClient.from(_tableName).update(institutionData).eq('id', id);
  }
  // remove Data
  Future<void> deleteInstitution(String id) async {
    await _supabaseClient.from(_tableName).delete().eq('id', id);
  }

}
