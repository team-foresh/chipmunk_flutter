import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../countrycode/country_code_page.dart';
import '../bloc/phone_number.dart';

class CountryCode extends StatelessWidget {
  final PhoneNumberBloc bloc;
  final FluroRouter router;

  const CountryCode(
    this.router,
    this.bloc, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
      builder: (context, state) {
        return InkWell(
          onTap: () async {
            final CountryCodeArgs result = await router.navigateTo(
              context,
              Routes.countryCodeRoute,
              routeSettings: RouteSettings(
                arguments: CountryCodeArgs(
                  countryCode: state.countryCode,
                  countryName: state.countryName,
                ),
              ),
              replace: false,
            );
            bloc.add(
              PhoneNumberChangeCountryCode(
                result.countryCode,
                result.countryName,
              ),
            );
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
                Text("${state.countryName} (${state.countryCode})", style: ChipmunkTextStyle.body1Regular()),
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: SvgPicture.asset("assets/icons/ic_arrow_down.svg"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
