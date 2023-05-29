import 'dart:io';

import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:dartz/dartz.dart';

class ChipmunkErrorMapper {
  ChipmunkFailure map(ChipmunkException error) {
    try {
      final int errorCode = int.parse(error.errorCode ?? "");
      final String? errorMessage = error.errorMessage;

      ChipmunkLogger.error("$errorCode: $errorMessage");
      switch (errorCode) {
        // 인증에러.
        case HttpStatus.forbidden:
        case HttpStatus.unauthorized:
          return AuthFailure(
            errorCode: errorCode.toString(),
            errorMessage: errorMessage,
          );
        // 공통에러
        default:
          return CommonFailure(
            errorCode: errorCode.toString(),
            errorMessage: errorMessage,
          );
      }
    } catch (e) {
      return UnknownFailure(
        errorMessage: e.toString(),
      );
    }
  }

  Either<ChipmunkFailure, T> mapAsLeft<T>(ChipmunkException error) => left(map(error));
}
