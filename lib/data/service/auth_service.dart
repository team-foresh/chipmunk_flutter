import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const supabaseSessionKey = 'supabase_session';
  static const _tag = '[AuthService] ';

  final GoTrueClient authClient;
  final SharedPreferences preferences;

  AuthService({
    required this.authClient,
    required this.preferences,
  });

  // 로그인.
  Future<bool> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await authClient
          .signInWithPassword(
        phone: phoneNumber,
        password: password,
      )
          .then(
        (value) {
          persistSession(value.session!);
          ChipmunkLogger.debug(tag: _tag, "signIn:: persistSession()");
          return true;
        },
      );
      return false;
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: "로그인에 실패.",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 회원가입.
  Future<AuthResponse> signUp({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await authClient.signUp(
        phone: phoneNumber,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: "회원가입 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 휴대폰번호 인증.
  Future<AuthResponse> verifyPhoneNumber({
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      final response = await authClient.verifyOTP(
        token: otpCode,
        phone: phoneNumber,
        type: OtpType.sms,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: "휴대폰번호 인증 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 로그아웃.
  Future<void> signOut() async {
    try {
      await authClient.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: "로그아웃 실패",
      );
    }
  }

  // 세션 유지.
  Future<void> persistSession(Session session) async {
    ChipmunkLogger.debug('PersistSession:: ${session.persistSessionString}');
    await preferences.setString(supabaseSessionKey, session.persistSessionString);
  }

  // 세션 복구.
  Future<String> recoverSession() async {
    try {
      if (preferences.containsKey(supabaseSessionKey)) {
        ChipmunkLogger.debug('RecoverSession:: 로그인 한 계정이 있음.');
        final jsonStr = preferences.getString(supabaseSessionKey)!;
        final response = await authClient.recoverSession(jsonStr);
        ChipmunkLogger.debug('RecoverSession:: 계정 복구 성공. >> ${response.user!.email}');
        persistSession(response.session!);
        return Routes.homeRoute;
      } else {
        ChipmunkLogger.debug('RecoverSession:: 로그인 한 계정이 없음.');
        return Routes.phoneNumberRoute;
      }
    } catch (e) {
      ChipmunkLogger.error('RecoverSession:: 계정 복구 실패. ${e.toString()}');
      return Routes.phoneNumberRoute;
    }
  }
}
