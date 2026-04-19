import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Models/ServicesModel.dart';


class ServiceService {
  final SupabaseClient _client;

  static const String _table = 'services';

  ServiceService(this._client);

  // ─── CREATE ───────────────────────────────────────────────────────────────

  Future<ServiceModel> createService(ServiceModel service) async {
    final response = await _client
        .from(_table)
        .insert(service.toJson())
        .select()
        .single();

    return ServiceModel.fromJson(response);
  }

  // ─── READ ─────────────────────────────────────────────────────────────────

  Future<ServiceModel?> getServiceById(String id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ServiceModel.fromJson(response);
  }

  Future<List<ServiceModel>> getAllServices() async {
    final response = await _client
        .from(_table)
        .select()
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> getServicesByInstitution(
      String institutionId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('institution_id', institutionId)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> getServicesByCategory(String category) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('category', category)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> getFreeServices() async {
    final response = await _client
        .from(_table)
        .select()
        .eq('is_free', true)
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((e) => ServiceModel.fromJson(e)).toList();
  }

  Future<List<ServiceModel>> searchServices(String query) async {
    final response = await _client
        .from(_table)
        .select()
        .or('name.ilike.%$query%,description.ilike.%$query%')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((e) => ServiceModel.fromJson(e)).toList();
  }

  // ─── UPDATE ───────────────────────────────────────────────────────────────

  Future<ServiceModel> updateService(ServiceModel service) async {
    final response = await _client
        .from(_table)
        .update(service.toJson())
        .eq('id', service.id!)
        .select()
        .single();

    return ServiceModel.fromJson(response);
  }

  Future<ServiceModel> toggleServiceStatus(
      String id, bool isActive) async {
    final response = await _client
        .from(_table)
        .update({'is_active': isActive})
        .eq('id', id)
        .select()
        .single();

    return ServiceModel.fromJson(response);
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────

  Future<void> deleteService(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }

  // ─── REALTIME ─────────────────────────────────────────────────────────────

  Stream<List<ServiceModel>> watchServicesByInstitution(
      String institutionId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('institution_id', institutionId)
        .order('created_at', ascending: false)
        .map((rows) => rows.map((e) => ServiceModel.fromJson(e)).toList());
  }
}