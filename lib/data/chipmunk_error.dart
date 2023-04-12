import 'package:equatable/equatable.dart';

abstract class ChipmunkFailure extends Equatable {
  final int code;
  final String? message;

  const ChipmunkFailure({
    required this.message,
    required this.code,
  }) : super();
}

/// 인증에러.
class AuthFailure extends ChipmunkFailure {
  final int errorCode;
  final String? errorMessage;

  const AuthFailure({
    this.errorCode = 1,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message];
}
