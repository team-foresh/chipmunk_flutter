import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 앱에서 지원하는 언어 리스트 변수

class Environment {
  static const tag = "[Environment]";
  static const translation = "assets/translations";

  Environment.create();

  /// 앱에서 지원하는 언어 리스트 변수
  static final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

  init() async {
    /// 세로모드 고정.
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
