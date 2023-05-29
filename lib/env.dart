import 'package:flutter/material.dart';

/// 앱에서 지원하는 언어 리스트 변수

abstract class Environment {
  static const tag = "[Environment]";
  static const translation = "assets/translations";
  static const baseUrl = "https://dapi.kakao.com";
  static const apiKey = "4de907c5603758606a619f75c90ef4c1";

  /// 앱에서 지원 하는 언어 리스트 변수
  static final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];
}
