import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

import '../../util/logger.dart';

class HttpLoggerInterceptor implements RequestInterceptor, ResponseInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final base = await request.toBaseRequest();
    ChipmunkLogger.info(tag: "[REQUEST]", '--> ${base.method} ${base.url}');

    ChipmunkLogger.info(tag: "[REQUEST]", base.headers.toString());

    var bytes = '';
    if (base is http.Request) {
      final body = base.body;
      if (body.isNotEmpty) {
        ChipmunkLogger.info(tag: "[REQUEST]", body);
        bytes = ' (${base.bodyBytes.length}-byte body)';
      }
    }

    ChipmunkLogger.info(tag: "[REQUEST]", '--> END ${base.method}$bytes');
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    final base = response.base.request;

    if (response.statusCode >= 400) {
      ChipmunkLogger.error('[RESPONSE] <-- ${response.statusCode} ${base!.url}');
    } else {
      ChipmunkLogger.info('[RESPONSE] <-- ${response.statusCode} ${base!.url}');
    }

    // response.base.headers.forEach((k, v) => debugPrint('$k: $v'));

    var bytes;
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body.isNotEmpty) {
        ChipmunkLogger.info("[RESPONSE] <-- ${resp.body}");
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }
    ChipmunkLogger.info('[RESPONSE] --> END ${base.method} $bytes');
    return response;
  }
}
