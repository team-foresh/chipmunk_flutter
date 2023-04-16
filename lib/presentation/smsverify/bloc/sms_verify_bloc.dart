import 'dart:async';
import 'dart:io';

import 'package:chipmunk_flutter/core/util/permission.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/domain/repository/auth_repository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'sms_verify.dart';

class SmsVerifyBloc extends Bloc<SmsVerifyEvent, SmsVerifyState>
    with SideEffectBlocMixin<SmsVerifyEvent, SmsVerifyState, SmsVerifySideEffect> {
  static const tag = "[SmsVerifyBloc]";

  final AuthRepository authRepository;

  SmsVerifyBloc({
    required this.authRepository,
  }) : super(SmsVerifyState.initial()) {
    on<SmsVerifyInit>(init);
    on<SmsVerifyInput>(input);
    on<SmsVerifyBottomButtonPressed>(bottomButtonPressed);
  }

  FutureOr<void> init(SmsVerifyInit event, Emitter<SmsVerifyState> emit) async {
    String phoneNumber = event.phoneNumber;
    bool isPermissionGranted = await ChipmunkPermissionUtil().requestPermission([Permission.sms]);
    emit(state.copyWith(phoneNumber: phoneNumber));

    // SMS 권한이 있는지 확인 > 안드로이드에서만 확인 함.
    if (!isPermissionGranted && Platform.isAndroid) {
      produceSideEffect(SmsVerifyOpenSetting());
      return;
    }
    produceSideEffect(SmsVerifyStartListening());
  }

  FutureOr<void> input(SmsVerifyInput event, Emitter<SmsVerifyState> emit) {
    String verifyCode = event.verifyCode;
    if (verifyCode.isNotEmpty) {
      bool isValid = ChipmunkValidator.isValidVerifyCode(event.verifyCode);
      emit(
        state.copyWith(
          verifyCode: verifyCode,
          isEnabled: isValid,
        ),
      );
      if (event.auto && isValid) {
        add(SmsVerifyBottomButtonPressed());
      }
    }
  }

  FutureOr<void> bottomButtonPressed(SmsVerifyBottomButtonPressed event, Emitter<SmsVerifyState> emit) async {
    await authRepository
        .verifyPhoneNumber(
          otpCode: state.verifyCode,
          phoneNumber: state.phoneNumber,
        )
        .then(
          (value) => value.fold(
            (l) => produceSideEffect(SmsVerifyError(l)),
            (r) {
              produceSideEffect(SmsVerifyMovePage(Routes.homeRoute));
            },
          ),
        );
  }
}
