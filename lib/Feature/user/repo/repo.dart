import '../../../core/Models/userModel.dart';
import '../../../core/Services/Supabase/userService.dart';


// Abstract interface — swap implementation for testing
abstract class UserRepository {
  Future<List<UserModel>> getAll();
  Future<List<UserModel>> getByDisabilityType(String type);
  Future<List<UserModel>> search(String query);
  Future<UserModel> getById(String id);
  Future<UserModel> create(UserModel user);
  Future<UserModel> update(String id, UserModel user);
  Future<void> delete(String id);
}

class UserRepositoryImpl implements UserRepository {
  final UserService _service;

  UserRepositoryImpl(this._service);

  @override
  Future<List<UserModel>> getAll() => _service.fetchAll();

  @override
  Future<List<UserModel>> getByDisabilityType(String type) =>
      _service.fetchByDisabilityType(type);

  @override
  Future<List<UserModel>> search(String query) => _service.search(query);

  @override
  Future<UserModel> getById(String id) => _service.fetchById(id);

  @override
  Future<UserModel> create(UserModel user) => _service.create(user);

  @override
  Future<UserModel> update(String id, UserModel user) =>
      _service.update(id, user);

  @override
  Future<void> delete(String id) => _service.delete(id);
}