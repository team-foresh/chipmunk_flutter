import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension FortuneContextEx on BuildContext {
  void handleError(
    ChipmunkFailure error, {
    Function0? btnOkOnPress,
  }) {
    final router = serviceLocator<ChipmunkRouter>().router;

    if (error is AuthFailure) {
      AwesomeDialog(
        context: this,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: ColorName.backgroundLight,
        buttonsTextStyle: ChipmunkTextStyle.button1Medium(fontColor: ColorName.backgroundLight),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        body: Container(
          color: ColorName.backgroundLight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              Text("cert_expiration".tr(), style: ChipmunkTextStyle.subTitle1Bold(fontColor: ColorName.active)),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  error.message ?? "No message",
                  style: ChipmunkTextStyle.body1Regular(fontColor: ColorName.activeDark),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        dialogBorderRadius: BorderRadius.circular(
          32.r,
        ),
        btnOkColor: ColorName.primary,
        btnOkText: "확인",
        btnOkOnPress: btnOkOnPress ??
            () {
              router.navigateTo(
                    this,
                    Routes.phoneNumberRoute,
                    clearStack: true,
                    replace: false,
                  );
            },
      ).show();
    } else {
      AwesomeDialog(
        context: this,
        animType: AnimType.scale,
        dialogType: DialogType.noHeader,
        dialogBackgroundColor: ColorName.backgroundLight,
        buttonsTextStyle: ChipmunkTextStyle.button1Medium(fontColor: ColorName.backgroundLight),
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: true,
        body: Container(
          color: ColorName.backgroundLight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              Text(error.code.toString(), style: ChipmunkTextStyle.subTitle1Bold(fontColor: ColorName.active)),
              SizedBox(height: 8.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  error.message ?? 'No message',
                  style: ChipmunkTextStyle.body1Regular(fontColor: ColorName.activeDark),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        dialogBorderRadius: BorderRadius.circular(
          32.r,
        ),
        btnOkColor: ColorName.primary,
        btnOkText: "확인",
        btnOkOnPress: btnOkOnPress ?? () {},
      ).show();
    }
  }
}
