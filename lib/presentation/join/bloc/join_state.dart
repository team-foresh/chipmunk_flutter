import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_state.freezed.dart';

@freezed
class JoinState with _$JoinState {
  factory JoinState({
    required String phoneNumber,
    required String password,
    required String passwordAgain,
    required bool isButtonEnabled,
    required String countryCode,
    required String countryName,
  }) = _JoinState;

  factory JoinState.initial() => JoinState(
        phoneNumber: "",
        password: "",
        passwordAgain: "",
        isButtonEnabled: false,
        countryCode: '+82',
        countryName: 'default_country_name'.tr(),
      );
}
