import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/domain/repository/auth_repository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'phone_number.dart';

class PhoneNumberBloc extends Bloc<PhoneNumberEvent, PhoneNumberState>
    with SideEffectBlocMixin<PhoneNumberEvent, PhoneNumberState, PhoneNumberSideEffect> {
  AuthRepository authRepository;

  static const tag = "[PhoneNumberBloc]";

  PhoneNumberBloc({
    required this.authRepository,
  }) : super(PhoneNumberState.initial()) {
    on<PhoneNumberInit>(init);
    on<PhoneNumberInput>(
      phoneNumberInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<PhoneNumberPasswordInput>(
      passwordInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<PhoneNumberCancel>(phoneNumberCancel);
    on<PhoneNumberPasswordCancel>(passwordCancel);
    on<PhoneNumberChangeCountryCode>(changeCountryCode);
    on<PhoneNumberBottomButtonClick>(clickNextButton);
  }

  FutureOr<void> init(PhoneNumberInit event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode ?? state.countryCode,
        countryName: event.countryName ?? state.countryName,
      ),
    );
  }

  FutureOr<void> phoneNumberInput(PhoneNumberInput event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: ChipmunkValidator.isValidPhoneNumber(event.phoneNumber),
      ),
    );
  }

  FutureOr<void> phoneNumberCancel(PhoneNumberCancel event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        phoneNumber: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> changeCountryCode(PhoneNumberChangeCountryCode event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        countryName: event.countryName,
      ),
    );
  }

  FutureOr<void> passwordInput(PhoneNumberPasswordInput event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isButtonEnabled: event.password.isNotEmpty,
      ),
    );
  }

  FutureOr<void> passwordCancel(PhoneNumberPasswordCancel event, Emitter<PhoneNumberState> emit) {
    emit(
      state.copyWith(
        password: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> clickNextButton(PhoneNumberBottomButtonClick event, Emitter<PhoneNumberState> emit) async {
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
            (l) => produceSideEffect(PhoneNumberError(l)),
            (isSignUp) {
              if (isSignUp) {
                produceSideEffect(PhoneNumberLandingScreen(Routes.homeRoute));
              } else {
                produceSideEffect(
                  PhoneNumberLandingScreen(
                    Routes.smsCertifyRoute,
                    phoneNumber: internationalPhoneNumber,
                  ),
                );
              }
            },
          ),
        );
  }
}
