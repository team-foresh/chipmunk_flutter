import 'dart:core';

import 'package:chipmunk_flutter/env.dart';
import 'package:chopper/chopper.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:synchronized/synchronized.dart';

import '../util/logger.dart';

const String authHeaderKey = 'Authorization';
const String contentType = 'content-type';

String authHeaderValue(String token) => 'KakaoAK $token';

class AuthHelperJwt {
  static final Lock _lock = Lock();

  Future<Request?> interceptResponse(Request request, Response response) async {
    ChipmunkLogger.info("interceptResponse():: ${response.body.toString()}");
    return null;
  }

  Future<Request> interceptRequest(Request request) async {
    // 헤더에 토큰이 있는지 확인.
    final String? tokenUsed = request.headers[authHeaderKey]?.substring('KakaoAK '.length);

    // 토큰이 있고 만료되지 않았을 경우.
    if (tokenUsed != null && !JwtDecoder.isExpired(tokenUsed)) {
      ChipmunkLogger.debug("interceptRequest():: Token is valid");
      return request;
    }

    // 토큰이 없거나 만료되었을 경우.
    final Request newRequestMaybe = await _lock.synchronized(
      () async {
        ChipmunkLogger.debug("interceptRequest():: lock");
        return applyHeader(
          request,
          authHeaderKey,
          authHeaderValue(Environment.apiKey),
          override: true,
        );
      },
      timeout: const Duration(seconds: 30),
    ).catchError((_) {}, test: (error) {
      ChipmunkLogger.error("interceptRequest():: Exception thrown: $error");
      return false;
    });
    ChipmunkLogger.debug("interceptRequest():: lock released");
    return newRequestMaybe;
  }
}
