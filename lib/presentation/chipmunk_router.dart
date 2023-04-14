import 'package:chipmunk_flutter/presentation/board/board_page.dart';
import 'package:chipmunk_flutter/presentation/countrycode/country_code_page.dart';
import 'package:chipmunk_flutter/presentation/phonenumber/phone_number_page.dart';
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
      return const PhoneNumberPage();
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
        Routes.phoneNumberRoute,
        handler: phoneNumberHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 홈..
      ..define(
        Routes.homeRoute,
        handler: homeHandler,
        transitionType: TransitionType.fadeIn,
      )

      /// 국가코드
      ..define(
        Routes.countryCodeRoute,
        handler: countryCodeHandler,
        transitionType: TransitionType.fadeIn,
      );
  }
}

class Routes {
  static const String homeRoute = 'homeRoute';
  static const String phoneNumberRoute = 'phoneNumberRoute';
  static const String countryCodeRoute = 'countryCodeRoute';
}
