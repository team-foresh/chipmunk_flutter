import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

import 'api/service/main_service.dart';
import 'auth_helper_jwt.dart';
import 'interceptor/auth_interceptor.dart';
import 'interceptor/http_logging_interceptor.dart';

class ApiServiceProvider {
  final ChopperClient _defaultClient;
  final AuthHelperJwt _authHelperJwt;

  factory ApiServiceProvider({
    required String baseUrl,
    http.Client? httpClient,
  }) {
    AuthHelperJwt authHelperJwt = AuthHelperJwt();
    // 인증이 필요한 클라이언트.
    ChopperClient authClient = ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      client: httpClient,
      converter: const JsonConverter(),
      services: [
        MainService.create(),
      ],
      errorConverter: const JsonConverter(),
      interceptors: [
        const HeadersInterceptor({
          'Cache-Control': 'no-cache',
        }),
        HttpLoggerInterceptor(),
        AuthInterceptor(authHelperJwt),
      ],
    );

    return ApiServiceProvider.withClients(
      authClient,
      authHelperJwt,
    );
  }

  ApiServiceProvider.withClients(
    ChopperClient authClient,
    this._authHelperJwt,
  ) : _defaultClient = authClient;

  AuthHelperJwt getAuthHelperJwt() => _authHelperJwt;

  MainService getMainService() => _defaultClient.getService<MainService>();
}
