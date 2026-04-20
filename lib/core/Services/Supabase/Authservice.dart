import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Models/AdminModel.dart';

class AuthService {
  final SupabaseClient _client;

  AuthService(this._client);

  // ─────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────
  Future<AdminModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _client
        .from('admin')
        .select()
        .eq('email', email)
        .eq('password', password)
        .eq('status', 'active')
        .single();

    return AdminModel.fromJson(response);
  }

  // ─────────────────────────────────────────
  // FORGOT PASSWORD
  // ─────────────────────────────────────────
  Future<void> forgotPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: null,
      );
    } on AuthException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    }
  }

  // ─────────────────────────────────────────
  // RESET PASSWORD (verify OTP + set new password)
  // ─────────────────────────────────────────
  Future<void> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      await _client.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.recovery,
      );

      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } on AuthException catch (e) {
      throw Exception('Reset password failed: ${e.message}');
    }
  }

  // ─────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────
  User? get currentUser => _client.auth.currentUser;
  bool get isLoggedIn => _client.auth.currentUser != null;
}