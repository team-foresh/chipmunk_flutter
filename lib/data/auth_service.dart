import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/chipmunk_error.dart';
import 'package:chipmunk_flutter/data/db/user_repository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final GoTrueClient authClient;
  final UserRepository userRepository;
  final SharedPreferences preferences;

  static const supabaseSessionKey = 'supabase_session';

  AuthService({
    required this.authClient,
    required this.userRepository,
    required this.preferences,
  });

  /// 로그인.
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authClient.signInWithPassword(email: email, password: password);
      _persistSession(response.session!);
      return true;
    } catch (e) {
      ChipmunkLogger.error('SignInWithEmail:: 로그인 실패. ${e.toString()}');
      return false;
    }
  }

  /// 회원가입.
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (!await userRepository.isEmailAlreadyRegistered(email)) {
        await authClient.signUp(email: email, password: password);
        userRepository.signUp(email);
      }
      return true;
    } on AuthFailure catch (e) {
      ChipmunkLogger.error('SignUpWithEmail:: 회원가입 실패. ${e.toString()}');
      rethrow;
    }
  }

  Future<bool> signOut() async {
    try {
      await authClient.signOut();
      return true;
    } catch (e) {
      ChipmunkLogger.error('SignOut:: 로그아웃 실패. ${e.toString()}');
      return false;
    }
  }

  Future<void> _persistSession(Session session) async {
    ChipmunkLogger.debug('PersistSession:: ${session.persistSessionString}');
    await preferences.setString(supabaseSessionKey, session.persistSessionString);
  }

  Future<String> recoverSession() async {
    try {
      if (preferences.containsKey(supabaseSessionKey)) {
        ChipmunkLogger.debug('RecoverSession:: 로그인 한 계정이 있음.');
        final jsonStr = preferences.getString(supabaseSessionKey)!;
        final response = await authClient.recoverSession(jsonStr);
        ChipmunkLogger.debug('RecoverSession:: 계정 복구 성공. >> ${response.user!.email}');
        _persistSession(response.session!);
        return Routes.homeRoute;
      } else {
        ChipmunkLogger.debug('RecoverSession:: 로그인 한 게정이 없음.');
        return Routes.loginRoute;
      }
    } catch (e) {
      ChipmunkLogger.error('RecoverSession:: 계정 복구 실패. ${e.toString()}');
      return Routes.loginRoute;
    }
  }

// // 이메일이 이미 가입되었는지 확인
// Future<bool> isEmailAlreadyRegistered(String email) async {
//   final response = await _client.from('auth.users').select('email').eq('email', email);
//
//   if (response.error != null) {
//     throw response.error!;
//   }
//
//   return response.data != null && response.data!.isNotEmpty;
// }
}
