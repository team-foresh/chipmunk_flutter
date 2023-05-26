import 'package:chipmunk_flutter/core/gen/assets.gen.dart';
import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/button/chipmunk_scale_button.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  final router = serviceLocator<ChipmunkRouter>().router;

  OnBoardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChipmunkScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Text(
            tr("onboarding_greeting_title"),
            style: ChipmunkTextStyle.headLine3(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            tr("onboarding_greeting_sub_title"),
            style: ChipmunkTextStyle.subTitle3Regular(
              fontColor: ColorName.activeDark,
            ),
            textAlign: TextAlign.center,
          ),
          Assets.icons.icOnboarding.svg(),
          const Spacer(),
          ChipmunkScaleButton(
            text: 'next'.tr(),
            press: () => router.navigateTo(
              context,
              Routes.requestPermissionRoute,
            ),
          )
        ],
      ),
    );
  }
}
