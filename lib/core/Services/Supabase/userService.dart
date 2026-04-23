import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Models/userModel.dart';


class UserService {
  final SupabaseClient _client;
  static const _table = 'people_with_disability';

  UserService(this._client);

  Future<List<UserModel>> fetchAll() async {
    final data = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);
    return (data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserModel>> fetchByDisabilityType(String type) async {
    final data = await _client
        .from(_table)
        .select()
        .eq('disability_type', type)
        .order('created_at', ascending: false);
    return (data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserModel>> search(String query) async {
    // Supabase ilike for case-insensitive partial match
    final data = await _client
        .from(_table)
        .select()
        .or('full_name.ilike.%$query%,email.ilike.%$query%,phone.ilike.%$query%')
        .order('created_at', ascending: false);
    return (data as List)
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel> fetchById(String id) async {
    final data = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .single();
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  Future<UserModel> create(UserModel user) async {
    final data = await _client
        .from(_table)
        .insert(user.toJson())
        .select()
        .single();
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  Future<UserModel> update(String id, UserModel user) async {
    final data = await _client
        .from(_table)
        .update(user.toJson())
        .eq('id', id)
        .select()
        .single();
    return UserModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}