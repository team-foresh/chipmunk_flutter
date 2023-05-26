import 'package:chipmunk_flutter/data/service/auth_service.dart';
import 'package:chipmunk_flutter/env.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'init.dart';

void main() async {
  await init();

  runApp(
    EasyLocalization(
      // 지원 언어 리스트
      supportedLocales: Environment.supportedLocales,
      // path: 언어 파일 경로
      path: Environment.translation,
      // supportedLocales에 설정한 언어가 없는 경우 설정되는 언어
      fallbackLocale: const Locale('en', 'US'),
      // startLocale을 지정하면 초기 언어가 설정한 언어로 변경됨.
      // 만일 이 설정을 하지 않으면 OS 언어를 따라 기본 언어가 설정됨.
      // startLocale: Locale('ko', 'KR')
      child: ChipmunkApp(
        startRoute: await serviceLocator<AuthService>().recoverSession(),
      ),
    ),
  );
}
