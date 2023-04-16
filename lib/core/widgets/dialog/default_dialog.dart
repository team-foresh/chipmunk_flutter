import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

extension FortuneDialogEx on BuildContext {
  void showChipmunkDialog({
    required String title,
    required String subTitle,
    required String btnOkText,
    required Function0 btnOkPressed,
    String? btnCancelText,
    Function0? btnCancelPressed,
  }) {
    AwesomeDialog(
      context: this,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      dialogBackgroundColor: ColorName.backgroundLight,
      buttonsTextStyle: ChipmunkTextStyle.button1Medium(fontColor: ColorName.backgroundLight),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Container(
        height: 120.h,
        color: ColorName.backgroundLight,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: ChipmunkTextStyle.subTitle1Bold(fontColor: ColorName.active)),
            SizedBox(height: 8.h),
            Text(subTitle, style: ChipmunkTextStyle.body1Regular(fontColor: ColorName.activeDark))
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
      btnCancelColor: ColorName.deActive,
      btnCancelText: btnCancelText,
      btnCancelOnPress: btnCancelPressed,
      btnOkText: btnOkText,
      btnOkOnPress: btnOkPressed,
    ).show();
  }

  void showFortuneMaterialDialog({
    required String title,
    required String message,
    required String buttonText,
    required Function0 onPressed,
    LottieBuilder? lottieBuilder,
  }) =>
      Dialogs.materialDialog(
        color: Colors.white,
        msg: message,
        title: title,
        barrierDismissible: false,
        lottieBuilder: lottieBuilder,
        barrierColor: Colors.black12.withOpacity(0.6),
        // Background color
        dialogWidth: kIsWeb ? 0.3 : null,
        context: this,
        actions: [
          SizedBox(
            height: 46,
            child: IconsButton(
              onPressed: onPressed,
              text: buttonText,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.amberAccent,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ),
        ],
      );
}
