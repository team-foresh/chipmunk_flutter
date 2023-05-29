import 'package:equatable/equatable.dart';

class ChipmunkException {
  final String? errorCode;
  final String? errorMessage;

  ChipmunkException({
    required this.errorCode,
    required this.errorMessage,
  });
}

abstract class ChipmunkFailure extends Equatable {
  final String? code;
  final String? message;
  final String? description;

  const ChipmunkFailure({
    this.code,
    this.message,
    this.description,
  }) : super();
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
    this.errorCode = '999',
    this.errorMessage,
    this.exposureMessage = "알 수 없는 에러",
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: exposureMessage,
        );

  @override
  List<Object?> get props => [message, errorCode];
}
