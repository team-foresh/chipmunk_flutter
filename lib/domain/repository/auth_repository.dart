import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/service/auth_service.dart';
import 'package:chipmunk_flutter/data/service/user_service.dart';
import 'package:chipmunk_flutter/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase/supabase.dart';

class AuthRepository {
  final AuthService authService;
  final UserService userService;

  AuthRepository({
    required this.authService,
    required this.userService,
  });

  // 로그인.
  Future<ChipmunkResult<void>> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final UserEntity? user = await userService.findUserByPhone(phoneNumber);
      if (user != null && user.verified) {
        final response = await authService.signIn(phoneNumber: phoneNumber, password: password);
        return Right(response);
      } else {
        throw const CommonFailure(exposureMessage: "가입된 사용자가 없습니다.");
      }
    } on ChipmunkFailure catch (e) {
      ChipmunkLogger.error(
        '[signIn] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }

  // 회원가입.
  Future<ChipmunkResult<AuthResponse>> signUp({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await authService.signUp(
        phoneNumber: phoneNumber,
        password: password,
      );
      final UserEntity? user = await userService.findUserByPhone(phoneNumber);
      // 회원이 없다면 회원테이블에 등록.
      if (user == null) {
        await userService.insert(phone: phoneNumber);
      }
      return Right(response);
    } on ChipmunkFailure catch (e) {
      ChipmunkLogger.error(
        '[signUp] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }

  // 휴대폰 번호 인증.
  Future<ChipmunkResult<AuthResponse>> verifyPhoneNumber({
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      final response = await authService.verifyPhoneNumber(
        otpCode: otpCode,
        phoneNumber: phoneNumber,
      );
      // 인증 처리.
      await userService.update(phoneNumber, verified: true);
      // 세션 저장.
      await authService.persistSession(response.session!);
      return Right(response);
    } on ChipmunkFailure catch (e) {
      ChipmunkLogger.error(
        '[verifyPhoneNumber] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }
}
