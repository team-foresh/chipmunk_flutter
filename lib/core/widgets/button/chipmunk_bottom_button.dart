import 'package:chipmunk_flutter/core/widgets/button/chipmunk_scale_button.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipmunkBottomButton extends StatelessWidget {
  final bool isEnabled;
  final Function0 onPress;
  final bool isKeyboardVisible;

  const ChipmunkBottomButton({
    Key? key,
    required this.isEnabled,
    required this.onPress,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChipmunkScaleButton(
      text: 'next'.tr(),
      isEnabled: isEnabled,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: isKeyboardVisible ? BorderRadius.circular(0.r) : BorderRadius.circular(100.r),
        ),
      ),
      press: onPress,
    );
  }
}
