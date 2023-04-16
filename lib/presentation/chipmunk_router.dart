import 'package:chipmunk_flutter/presentation/board/board_page.dart';
import 'package:chipmunk_flutter/presentation/countrycode/country_code_page.dart';
import 'package:chipmunk_flutter/presentation/join/join_page.dart';
import 'package:chipmunk_flutter/presentation/login/login_page.dart';
import 'package:chipmunk_flutter/presentation/smsverify/sms_verify_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class ChipmunkRouter {
  late final FluroRouter router;

  static var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return BoardPage();
    },
  );

  static var smsCertifyHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as SmsVerifyArgs?;
      final phoneNumber = args?.phoneNumber ?? "";
      return SmsVerifyPage(
        phoneNumber: phoneNumber,
      );
    },
  );

  static var phoneNumberHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const LoginPage();
    },
  );

  static var joinHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const JoinPage();
    },
  );

  static var countryCodeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      final args = context?.settings?.arguments as CountryCodeArgs?;
      final countryCode = args?.countryCode;
      final countryName = args?.countryName;
      return CountryCodePage(
        countryCode: countryCode,
        countryName: countryName,
      );
    },
  );

  void init() {
    router = FluroRouter()

      /// 로그인.
      ..define(
        Routes.loginRoute,
        handler: phoneNumberHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 홈.
      ..define(
        Routes.homeRoute,
        handler: homeHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// SMS 인증 화면.
      ..define(
        Routes.smsCertifyRoute,
        handler: smsCertifyHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 국가코드.
      ..define(
        Routes.countryCodeRoute,
        handler: countryCodeHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 회원가입.
      ..define(
        Routes.joinRoute,
        handler: joinHandler,
        transitionType: TransitionType.fadeIn,
      );
  }
}

class Routes {
  static const String homeRoute = 'homeRoute';
  static const String loginRoute = 'loginRoute';
  static const String joinRoute = 'joinRoute';
  static const String smsCertifyRoute = 'smsCertifyRoute';
  static const String countryCodeRoute = 'countryCodeRoute';
}
