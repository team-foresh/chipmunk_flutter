import 'package:chipmunk_flutter/core/widgets/button/chipmunk_bottom_button.dart';
import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class LoginBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final FluroRouter router;
  final Function0 onPressed;
  final bool isEnabled;

  const LoginBottomButton(
    this.isKeyboardVisible,
    this.router, {
    super.key,
    required this.onPressed,
    this.isEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChipmunkBottomButton(
      isKeyboardVisible: isKeyboardVisible,
      isEnabled: isEnabled,
      onPress: onPressed,
    );
  }
}
