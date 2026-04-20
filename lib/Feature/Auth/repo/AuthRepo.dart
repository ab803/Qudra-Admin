import '../../../core/Models/AdminModel.dart';
import '../../../core/Services/Supabase/Authservice.dart';


class AuthRepo {
  final AuthService _authService;

  AuthRepo(this._authService);

  Future<AdminModel> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email: email, password: password);
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}