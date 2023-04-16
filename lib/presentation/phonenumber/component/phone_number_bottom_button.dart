import 'package:chipmunk_flutter/core/widgets/button/chipmunk_bottom_button.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/phone_number.dart';

class PhoneNumberBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final FluroRouter router;
  final PhoneNumberBloc bloc;

  const PhoneNumberBottomButton(this.isKeyboardVisible,
      this.router,
      this.bloc, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
      builder: (context, state) {
        return ChipmunkBottomButton(
          isKeyboardVisible: isKeyboardVisible,
          isEnabled: state.isButtonEnabled,
          onPress: () {
            bloc.add(PhoneNumberBottomButtonClick());
            // router.navigateTo(
            //   context,
            //   Routes.smsCertifyRoute,
            //   routeSettings: RouteSettings(
            //     arguments: SmsVerifyArgs(
            //       phoneNumber: state.phoneNumber,
            //       countryCode: state.countryCode,
            //     ),
            //   ),
            // );
          },
        );
      },
    );
  }
}
