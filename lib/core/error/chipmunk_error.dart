import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChipmunkFailure extends Equatable {
  final String? code;
  final String? message;

  const ChipmunkFailure({
    required this.message,
    required this.code,
  }) : super();
}

/// DB 에러.
class PostgrestFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const PostgrestFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message, errorCode];
}

/// 인증 에러.
class AuthFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message, errorCode];
}

/// 알 수 없는 에러.
class UnknownFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const UnknownFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message, errorCode];
}

extension TryCatchRethrowExtension<T> on Future<T> {
  Future<Either<ChipmunkFailure, T>> toEntity() async {
    try {
      return Right(await this);
    } on PostgrestException catch (e) {
      ChipmunkLogger.error(
        '[PostgrestException] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'details: ${e.details}, '
        'hint: ${e.hint}',
      );
      return Left(
        PostgrestFailure(
          errorCode: e.code,
          errorMessage: e.message,
        ),
      );
    } on AuthException catch (e) {
      ChipmunkLogger.error(
        '[AuthException] - '
        'errorCode: ${e.statusCode}, '
        'errorMessage: ${e.message}, ',
      );
      return Left(
        AuthFailure(
          errorCode: e.statusCode,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      ChipmunkLogger.error(
        '[UnknownFailure] - '
        'errorCode: null, '
        'errorMessage: ${e.toString()}, ',
      );
      return Left(
        UnknownFailure(
          errorCode: null,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

typedef ChipmunkResult<T> = Either<ChipmunkFailure, T>;
