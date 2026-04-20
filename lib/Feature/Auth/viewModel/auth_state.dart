// auth_state.dart
part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AdminModel admin;
  AuthSuccess(this.admin);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}