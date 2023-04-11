import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/gen/fonts.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

theme() {
  return ThemeData(
    scaffoldBackgroundColor: ColorName.background,
    fontFamily: FontFamily.pretendard,
    appBarTheme: appBarTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
    // textTheme: textTheme(),
    bottomSheetTheme: bottomSheetTheme(),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: ColorName.primary),
    inputDecorationTheme: inputDecorationTheme(),
    bottomNavigationBarTheme: bottomNavigationBarTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

bottomSheetTheme() {
  return const BottomSheetThemeData(
    backgroundColor: ColorName.background,
  );
}

elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(
        56.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.r),
      ),
      // Enabled button color
      backgroundColor: ColorName.primary,
      // Disabled button color
      disabledBackgroundColor: ColorName.backgroundLight,
      // Enabled text color
      foregroundColor: ColorName.backgroundLight,
      // Disabled text color
      disabledForegroundColor: ColorName.deActive,
      textStyle: ChipmunkTextStyle.button1Medium(),
    ),
  );
}

bottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: ColorName.background,
    selectedLabelStyle: TextStyle(
      fontFamily: FontFamily.pretendardRegular,
      color: Colors.white,
      fontSize: 13.sp,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: FontFamily.pretendardRegular,
      color: ColorName.deActive,
      fontSize: 13.sp,
    ),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.white,
    unselectedItemColor: ColorName.deActive,
    showUnselectedLabels: true,
    showSelectedLabels: true,
  );
}

inputDecorationTheme() {
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    // contentPadding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorName.deActiveDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorName.deActiveDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorName.primary),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorName.negative),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: const BorderSide(color: ColorName.deActiveDark),
    ),
    counterStyle: const TextStyle(color: ColorName.primary),
  );
}

/// 텍스트 종류가 많지 않아서 사용하지 않음.
// TextTheme textTheme() {
//   return const TextTheme(
//     bodyText1: TextStyle(color: Colors.black),
//     bodyText2: TextStyle(color: Colors.black),
//   );
// }

appBarTheme() {
  return AppBarTheme(
    color: ColorName.background,
    elevation: 0,
    iconTheme: const IconThemeData(color: Colors.white24),
    toolbarTextStyle: ChipmunkTextStyle.subTitle2Medium(),
    titleTextStyle: ChipmunkTextStyle.subTitle2Medium(),
    titleSpacing: 0.w,
    toolbarHeight: 60.h,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      // For iOS (dark icons)
      statusBarIconBrightness: Brightness.light,
      // For Android (dark icons)
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: ColorName.background,
    ),
  );
}
