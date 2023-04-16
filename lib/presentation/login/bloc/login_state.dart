import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    required String phoneNumber,
    required String password,
    required bool isButtonEnabled,
    required String countryCode,
    required String countryName,
  }) = _LoginState;

  factory LoginState.initial() => LoginState(
        phoneNumber: "",
        password: "",
        isButtonEnabled: false,
        countryCode: '+82',
        countryName: 'default_country_name'.tr(),
      );
}
