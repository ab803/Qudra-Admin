// auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/Models/AdminModel.dart';
import '../repo/AuthRepo.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final admin = await _authRepo.login(email: email, password: password);
      emit(AuthSuccess(admin));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    emit(AuthInitial());
  }
}