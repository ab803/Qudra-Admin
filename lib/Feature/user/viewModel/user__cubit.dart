import 'package:admin_qudra/Feature/user/viewModel/user__state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/repo.dart';


class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> loadUsers() async {
    emit(UserLoading());
    try {
      final users = await _repository.getAll();
      emit(UserLoaded(users: users));
    } catch (e) {
      emit(UserError('Failed to load users: $e'));
    }
  }

  Future<void> filterByDisability(String type) async {
    final current = state;
    if (current is! UserLoaded) return;

    emit(UserLoading());
    try {
      final users = type == 'All'
          ? await _repository.getAll()
          : await _repository.getByDisabilityType(type);
      emit(current.copyWith(users: users, activeFilter: type));
    } catch (e) {
      emit(UserError('Failed to filter users: $e'));
    }
  }

  Future<void> searchUsers(String query) async {
    final current = state;
    if (current is! UserLoaded) return;

    if (query.trim().isEmpty) {
      await loadUsers();
      return;
    }

    try {
      final users = await _repository.search(query.trim());
      emit(current.copyWith(users: users, searchQuery: query));
    } catch (e) {
      emit(UserError('Search failed: $e'));
    }
  }

  Future<void> deleteUser(String id) async {
    final current = state;
    if (current is! UserLoaded) return;

    try {
      await _repository.delete(id);
      final updated = current.users.where((u) => u.id != id).toList();
      emit(UserActionSuccess(
        message: 'User deleted successfully',
        users: updated,
      ));
      // Restore loaded state with updated list
      emit(current.copyWith(users: updated));
    } catch (e) {
      emit(UserError('Failed to delete user: $e'));
    }
  }
}