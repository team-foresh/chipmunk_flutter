import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:equatable/equatable.dart';

abstract class ChipmunkFailure extends Equatable {
  final String? code;
  final String? message;

  const ChipmunkFailure({
    required this.message,
    required this.code,
  }) : super();
}

/// 사용자 에러.
class UserFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const UserFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message];
}

class BoardFailure extends ChipmunkFailure {
  final String? errorCode;
  final String? errorMessage;

  const BoardFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(code: errorCode, message: errorMessage);

  @override
  List<Object?> get props => [message];
}

extension TryCatchRethrowExtension<T> on Future<T> {
  Future<T> getOrThrow() async {
    try {
      return await this;
    } catch (e) {
      ChipmunkLogger.error(e.toString());
      rethrow;
    }
  }
}
