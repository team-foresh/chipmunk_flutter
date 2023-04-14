import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/core/widgets/textform/chipmunk_text_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/phone_number.dart';

class PhoneNumberInputField extends StatelessWidget {
  final PhoneNumberBloc bloc;
  final TextEditingController textEditingController;

  const PhoneNumberInputField(
    this.bloc, {
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberBloc, PhoneNumberState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ChipmunkTextForm(
            textEditingController: textEditingController,
            suffixIcon: "assets/icons/ic_cancel_circle.svg",
            onSuffixIconClicked: () {
              textEditingController.clear();
              bloc.add(PhoneNumberCancel());
            },
            maxLength: 12,
            onTextChanged: (text) {
              bloc.add(PhoneNumberInput(text));
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hint: 'require_certify_phone_number_hint'.tr(),
            errorMessage: () {
              if (state.phoneNumber.isNotEmpty && !ChipmunkValidator.isValidPhoneNumber(state.phoneNumber)) {
                return 'require_certify_phone_number_error'.tr();
              } else {
                return null;
              }
            }(),
          ),
        );
      },
    );
  }
}
