import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/service/auth_service.dart';
import 'package:chipmunk_flutter/data/service/board_service.dart';
import 'package:chipmunk_flutter/data/service/country_code_service.dart';
import 'package:chipmunk_flutter/data/service/user_service.dart';
import 'package:chipmunk_flutter/domain/country_repository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:chipmunk_flutter/presentation/countrycode/bloc/country_code.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/phonenumber/bloc/phone_number_bloc.dart';

final serviceLocator = GetIt.instance;

init() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 로거 초기화.
  await _initAppLogger();

  /// 다국어 설정.
  await EasyLocalization.ensureInitialized();

  /// 로컬 데이터 - Preference.
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  /// Supabase todo url이랑 키값 옮겨야됨.
  await Supabase.initialize(
    url: "https://zijhkonihriwfrffefwm.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inppamhrb25paHJpd2ZyZmZlZndtIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY4MTE3MDU1MSwiZXhwIjoxOTk2NzQ2NTUxfQ.qdyZq-TWQQ41azrCCgax0Y0mN4iNAaNXdF69lngJPOI",
    debug: false,
    schema: 'public',
    headers: {
      'apikey':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inppamhrb25paHJpd2ZyZmZlZndtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODExNzA1NTEsImV4cCI6MTk5Njc0NjU1MX0.BiXrxBGJVHpbdQWZGLhQD5tDPxU7ZrILVElac_ZP6P4'
    },
  );

  /// data.
  _initService();

  /// domain.
  _initRepository();

  /// Bloc.
  _initBloc();

  /// 계정 서비스.
  serviceLocator.registerLazySingleton<AuthService>(
    () => AuthService(
      authClient: Supabase.instance.client.auth,
      preferences: sharedPreferences,
    ),
  );

  /// Router.
  serviceLocator.registerLazySingleton<ChipmunkRouter>(() => ChipmunkRouter()..init());

  /// SharedPreferences
  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initService() {
  serviceLocator.registerLazySingleton<UserService>(
    () => UserService(
      Supabase.instance.client,
    ),
  );
  serviceLocator.registerLazySingleton<BoardService>(
    () => BoardService(
      Supabase.instance.client,
      serviceLocator<UserService>(),
    ),
  );

  serviceLocator.registerLazySingleton<CountryCodeService>(
    () => CountryCodeService(
      Supabase.instance.client,
    ),
  );
}

_initRepository() {
  serviceLocator.registerLazySingleton<CountryCodeRepository>(
    () => CountryCodeRepository(
      countryCodeService: serviceLocator<CountryCodeService>(),
    ),
  );
}

/// 로거.
_initAppLogger() {
  final appLogger = AppLogger(
    Logger(
      printer: PrettyPrinter(
        methodCount: 3,
        // 보이는 메소드 콜 갯수.
        errorMethodCount: 8,
        // 보이는 에러 메소드 콜 갯수.
        lineLength: 120,
        // 라인 넓이.
        colors: true,
        // 컬러적용.
        printEmojis: true,
        // 이모티콘 보이기.
        printTime: false, // 타임스탬프.
      ),
    ),
  );

  /// 앱로거.
  serviceLocator.registerLazySingleton<AppLogger>(() => appLogger);
}

/// Bloc.
_initBloc() {
  serviceLocator.registerFactory(() => PhoneNumberBloc());
  serviceLocator.registerFactory(
    () => CountryCodeBloc(
      countryCodeRepository: serviceLocator<CountryCodeRepository>(),
    ),
  );
}
