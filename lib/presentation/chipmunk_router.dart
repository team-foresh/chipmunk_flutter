import 'package:chipmunk_flutter/presentation/board/board_page.dart';
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

  static var phoneNumberHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const LoginPage();
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
      );
  }
}

class Routes {
  static const String homeRoute = 'homeRoute';
  static const String loginRoute = 'loginRoute';
}
