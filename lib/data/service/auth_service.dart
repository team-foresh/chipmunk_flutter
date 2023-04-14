import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final GoTrueClient authClient;
  final SharedPreferences preferences;

  static const supabaseSessionKey = 'supabase_session';

  AuthService({
    required this.authClient,
    required this.preferences,
  });

  // 로그인.
  Future<Either<ChipmunkFailure, AuthResponse>> signInWithPhoneNumber({
    required String phoneNumber,
    required String password,
  }) async {
    return await authClient
        .signInWithPassword(
          phone: phoneNumber,
          password: password,
        )
        .toEntity();
  }

  // 회원가입.
  Future<Either<ChipmunkFailure, AuthResponse>> signUpWithPhoneNumber({
    required String phoneNumber,
    required String password,
  }) async {
    return await authClient
        .signUp(
          phone: phoneNumber,
          password: password,
        )
        .toEntity();
  }

  // 휴대폰번호 인증.
  Future<Either<ChipmunkFailure, AuthResponse>> verifyPhoneNumber({
    required String number,
  }) async {
    return await authClient
        .verifyOTP(
          token: number,
          phone: authClient.currentUser?.phone,
          type: OtpType.sms,
        )
        .toEntity();
  }

  // 로그아웃.
  Future<Either<ChipmunkFailure, void>> signOut() async {
    return await authClient.signOut().toEntity();
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
