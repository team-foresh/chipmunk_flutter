import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class ChipmunkTextStyle {
  static TextStyle body1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body1Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body2Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body2SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 16.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body3Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 15.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle body3Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 15.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle button1Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 18.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle caption1SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 11.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine1({Color? fontColor}) {
    return TextStyle(
      fontSize: 36.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine2({Color? fontColor}) {
    return TextStyle(
      fontSize: 30.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle headLine3({Color? fontColor}) {
    return TextStyle(
      fontSize: 28.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle1Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 24.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle1Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 24.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle2Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 22.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle2SemiBold({Color? fontColor}) {
    return TextStyle(
      fontSize: 22.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardSemiBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3Bold({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardBold,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3Medium({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardMedium,
      color: fontColor ?? ColorName.active,
    );
  }

  static TextStyle subTitle3Regular({Color? fontColor}) {
    return TextStyle(
      fontSize: 20.sp,
      letterSpacing: -0.06,
      fontStyle: FontStyle.normal,
      fontFamily: FontFamily.pretendardRegular,
      color: fontColor ?? ColorName.active,
    );
  }
}
