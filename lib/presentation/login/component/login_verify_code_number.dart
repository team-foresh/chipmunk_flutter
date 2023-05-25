import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/core/widgets/button/chipmunk_text_button.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class LoginVerifyCodeNumber extends StatelessWidget {
  const LoginVerifyCodeNumber({
    super.key,
    required String verifyCode,
    required bool isRequestVerifyCodeEnable,
    required TextEditingController verifyCodeController,
    required this.onRequestClick,
    required this.onTextChanged,
  })  : _verifyCodeController = verifyCodeController,
        _isRequestVerifyCodeEnable = isRequestVerifyCodeEnable,
        _verifyCode = verifyCode;

  final Function0 onRequestClick;
  final Function1<String, void> onTextChanged;
  final TextEditingController _verifyCodeController;
  final String _verifyCode;
  final bool _isRequestVerifyCodeEnable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: TextFormField(
              autofocus: true,
              style: ChipmunkTextStyle.button1Medium(),
              controller: _verifyCodeController,
              onChanged: onTextChanged,
              decoration: InputDecoration(
                isDense: false,
                hintText: "인증번호를 입력하세요",
                contentPadding: EdgeInsets.all(16),
                counterText: "",
                hintStyle: ChipmunkTextStyle.subTitle3Regular(fontColor: ColorName.deActive),
                errorText:
                    ChipmunkValidator.isValidVerifyCode(_verifyCode) || _verifyCode.isEmpty ? null : "인증번호는 숫자 6자리입니다.",
                errorStyle: ChipmunkTextStyle.body3Regular(fontColor: ColorName.negative),
              ),
            ),
          ),
          SizedBox(width: 16),
          ChipmunkTextButton(
            onPress: _isRequestVerifyCodeEnable ? () => onRequestClick() : null,
            text: '인증번호 요청',
          ),
        ],
      ),
    );
  }
}
