import 'dart:convert';
import 'dart:io';

import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/network/api/chipmunk_main_error_mapper.dart';
import 'package:chipmunk_flutter/core/network/api/chipmunk_main_error_response.dart';
import 'package:chopper/chopper.dart';
import 'package:dartz/dartz.dart';


extension ChipmunkResponseMapper on Response {
  dynamic response() {
    dynamic decodedData;
    if (bodyBytes.isNotEmpty) {
      decodedData = jsonDecode(utf8.decode(bodyBytes));
    }
    return decodedData;
  }

  ChipmunkErrorResponse? errorResponse() {
    dynamic decodedData;
    if (bodyBytes.isNotEmpty) {
      decodedData = jsonDecode(utf8.decode(bodyBytes));
      return ChipmunkErrorResponse.fromJson(decodedData);
    }
    return decodedData;
  }

  dynamic toResponseData() {
    if (isSuccessful) {
      return response();
    } else {
      throw ChipmunkException(
        errorCode: base.statusCode.toString(),
        errorMessage: "${base.request?.url.path}",
      );
    }
  }
}

extension ChipmunkDomainMapper<T> on Future<T> {
  Future<Either<ChipmunkFailure, T>> toRemoteDomainData(ChipmunkErrorMapper errorMapper) async {
    try {
      return Right(await this);
    } on ChipmunkException catch (e) {
      return errorMapper.mapAsLeft(e);
    }
  }

  Future<Either<ChipmunkFailure, T>> toLocalDomainData(ChipmunkErrorMapper errorMapper) async {
    try {
      return Right(await this);
    } catch (e) {
      return errorMapper.mapAsLeft(
        ChipmunkException(
          errorCode: HttpStatus.badRequest.toString(),
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
