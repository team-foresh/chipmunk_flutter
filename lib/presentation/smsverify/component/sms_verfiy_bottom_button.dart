import 'package:chipmunk_flutter/core/widgets/button/chipmunk_bottom_button.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sms_verify.dart';

class SmsVerifyBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final Function0 onPress;

  const SmsVerifyBottomButton({
    required this.onPress,
    required this.isKeyboardVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmsVerifyBloc, SmsVerifyState>(
      builder: (context, state) {
        return ChipmunkBottomButton(
          isEnabled: state.isEnabled,
          onPress: onPress,
          isKeyboardVisible: isKeyboardVisible,
        );
      },
    );
  }
}
