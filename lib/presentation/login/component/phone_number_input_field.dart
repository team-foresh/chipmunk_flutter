import 'package:chipmunk_flutter/core/widgets/textform/chipmunk_text_form.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function0 onSuffixIconClicked;
  final Function1<String, void> onTextChanged;
  final bool isShowErrorMsg;

  const PhoneNumberInputField({
    Key? key,
    required this.textEditingController,
    required this.onSuffixIconClicked,
    required this.onTextChanged,
    this.isShowErrorMsg = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ChipmunkTextForm(
        textEditingController: textEditingController,
        suffixIcon: "assets/icons/ic_cancel_circle.svg",
        onSuffixIconClicked: () {
          textEditingController.clear();
          onSuffixIconClicked();
        },
        maxLength: 12,
        onTextChanged: onTextChanged,
        keyboardType: TextInputType.phone,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        hint: 'require_certify_phone_number_hint'.tr(),
        errorMessage: () {
          if (isShowErrorMsg) {
            return 'require_certify_phone_number_error'.tr();
          } else {
            return null;
          }
        }(),
      ),
    );
  }
}
