import 'package:chipmunk_flutter/presentation/home_page.dart';
import 'package:chipmunk_flutter/presentation/login_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class ChipmunkRouter {
  late final FluroRouter router;

  static var homeHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const HomePage();
    },
  );

  static var loginHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
      return const LoginPage();
    },
  );

  void init() {
    router = FluroRouter()

      /// 로그인.
      ..define(
        Routes.loginRoute,
        handler: loginHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 홈..
      ..define(
        Routes.homeRoute,
        handler: homeHandler,
        transitionType: TransitionType.fadeIn,
      );
  }
}

class Routes {
  static const String loginRoute = 'loginRoute';
  static const String homeRoute = 'homeRoute';
}
