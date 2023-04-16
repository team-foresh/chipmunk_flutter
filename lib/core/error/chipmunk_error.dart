import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

typedef ChipmunkResult<T> = Either<ChipmunkFailure, T>;

abstract class ChipmunkFailure extends Equatable {
  final String? code;
  final String? message;
  final String? description;

  const ChipmunkFailure({this.code, this.message, this.description}) : super();
}

/// 인증 에러.
class AuthFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
    this.exposureMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: exposureMessage,
        );

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

/// 공통 에러.
class CommonFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const CommonFailure({
    this.errorCode,
    this.errorMessage,
    this.exposureMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: exposureMessage,
        );

  @override
  List<Object?> get props => [message, errorCode];
}

/// 알 수 없는 에러.
class UnknownFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const UnknownFailure({
    this.errorCode,
    this.errorMessage,
    this.exposureMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: exposureMessage,
        );

  @override
  List<Object?> get props => [message, errorCode];
}

extension TryCatchRethrowExtension<T> on Future<T> {
  Future<Either<ChipmunkFailure, T>> toEither() async {
    try {
      return Right(await this);
    } on CommonFailure catch (e) {
      ChipmunkLogger.error(
        '[UserFailure] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.exposureMessage}',
      );
      return Left(e);
    } on AuthFailure catch (e) {
      ChipmunkLogger.error(
        '[AuthFailure] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.exposureMessage}',
      );
      return Left(e);
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
