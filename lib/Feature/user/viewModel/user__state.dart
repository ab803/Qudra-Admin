import '../../../core/Models/userModel.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserModel> users;
  final String activeFilter; // 'All', 'Visual', 'Physical', etc.
  final String searchQuery;

  UserLoaded({
    required this.users,
    this.activeFilter = 'All',
    this.searchQuery = '',
  });

  UserLoaded copyWith({
    List<UserModel>? users,
    String? activeFilter,
    String? searchQuery,
  }) {
    return UserLoaded(
      users: users ?? this.users,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserActionSuccess extends UserState {
  final String message;
  final List<UserModel> users;
  UserActionSuccess({required this.message, required this.users});
}