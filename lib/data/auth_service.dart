import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final GoTrueClient _auth;
  final SharedPreferences _preferences;

  static const supabaseSessionKey = 'supabase_session';

  AuthService(
    this._auth,
    this._preferences,
  );

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithPassword(email: email, password: password);
      _persistSession(response.session!);
      return true;
    } catch (e) {
      ChipmunkLogger.error('SignInWithEmail:: 로그인 실패. ${e.toString()}');
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signUp(email: email, password: password);
      _persistSession(response.session!);
      return true;
    } catch (e) {
      ChipmunkLogger.error('SignUpWithEmail:: 회원가입 실패. ${e.toString()}');
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      ChipmunkLogger.error('SignOut:: 로그아웃 실패. ${e.toString()}');
      return false;
    }
  }

  Future<void> _persistSession(Session session) async {
    ChipmunkLogger.debug('PersistSession:: ${session.persistSessionString}');
    await _preferences.setString(supabaseSessionKey, session.persistSessionString);
  }

  Future<String> recoverSession() async {
    try {
      if (_preferences.containsKey(supabaseSessionKey)) {
        ChipmunkLogger.debug('RecoverSession:: 로그인 한 계정이 있음.');
        final jsonStr = _preferences.getString(supabaseSessionKey)!;
        final response = await _auth.recoverSession(jsonStr);
        ChipmunkLogger.debug('RecoverSession:: 계정 복구 성공. >> ${response.user!.id}');
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
}
