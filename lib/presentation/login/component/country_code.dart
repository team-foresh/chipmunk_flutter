import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../countrycode/country_code_page.dart';

class CountryCode extends StatelessWidget {
  final FluroRouter router;
  final Function1<CountryCodeArgs, void> onTap;
  final String countryCode;
  final String countryName;

  const CountryCode(
    this.router, {
    required this.onTap,
    this.countryCode = "",
    this.countryName = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final CountryCodeArgs result = await router.navigateTo(
          context,
          Routes.countryCodeRoute,
          routeSettings: RouteSettings(
            arguments: CountryCodeArgs(
              countryCode: countryCode,
              countryName: countryName,
            ),
          ),
          replace: false,
        );
        onTap(result);
      },
      borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 8.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$countryName ($countryCode)", style: ChipmunkTextStyle.body1Regular()),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: SvgPicture.asset("assets/icons/ic_arrow_down.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
