import 'package:chipmunk_flutter/core/widgets/textform/chipmunk_text_form.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum PasswordType { normal, again }

class PasswordInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hint;
  final Function0 onSuffixIconClicked;
  final Function1<String, void> onTextChanged;

  const PasswordInputField({
    Key? key,
    required this.textEditingController,
    required this.onSuffixIconClicked,
    required this.onTextChanged,
    this.hint = 'require_certify_password_hint',
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
        keyboardType: TextInputType.text,
        hint: 'require_certify_password_hint'.tr(),
        errorMessage: null,
      ),
    );
  }
}
