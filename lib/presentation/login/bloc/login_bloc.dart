import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/domain/repository/auth_repository.dart';
import 'package:chipmunk_flutter/domain/repository/user_respository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'login.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> with SideEffectBlocMixin<LoginEvent, LoginState, LoginSideEffect> {
  AuthRepository authRepository;

  static const tag = "[PhoneNumberBloc]";

  LoginBloc({
    required this.authRepository,
  }) : super(LoginState.initial()) {
    on<LoginInit>(init);
    on<LoginPhoneNumberInput>(
      phoneNumberInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<LoginPasswordInput>(
      passwordInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<LoginPhoneNumberCancel>(phoneNumberCancel);
    on<LoginPasswordCancel>(passwordCancel);
    on<LoginChangeCountryCode>(changeCountryCode);
    on<LoginBottomButtonClick>(clickNextButton);
  }

  FutureOr<void> init(LoginInit event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode ?? state.countryCode,
        countryName: event.countryName ?? state.countryName,
      ),
    );
  }

  FutureOr<void> phoneNumberInput(LoginPhoneNumberInput event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: ChipmunkValidator.isValidPhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> phoneNumberCancel(LoginPhoneNumberCancel event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        phoneNumber: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> changeCountryCode(LoginChangeCountryCode event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        countryName: event.countryName,
      ),
    );
  }

  FutureOr<void> passwordInput(LoginPasswordInput event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isButtonEnabled: event.password.isNotEmpty,
      ),
    );
  }

  FutureOr<void> passwordCancel(LoginPasswordCancel event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(
        password: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> clickNextButton(LoginBottomButtonClick event, Emitter<LoginState> emit) async {
    String phoneNumber = state.phoneNumber;
    String countryCode = state.countryCode;
    String internationalPhoneNumber = phoneNumber.replaceFirst("0", countryCode);
    await authRepository
        .signIn(
          phoneNumber: internationalPhoneNumber,
          password: state.password,
        )
        .then(
          (value) => value.fold(
            (l) => produceSideEffect(LoginError(l)),
            (r) {
              produceSideEffect(LoginLandingScreen(Routes.homeRoute));
            },
          ),
        );
  }
}
