import 'dart:async';

import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/domain/repository/auth_repository.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'join.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> with SideEffectBlocMixin<JoinEvent, JoinState, JoinSideEffect> {
  AuthRepository authRepository;

  static const tag = "[PhoneNumberBloc]";

  JoinBloc({
    required this.authRepository,
  }) : super(JoinState.initial()) {
    on<JoinInit>(init);
    on<JoinPhoneNumberInput>(
      phoneNumberInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<JoinPasswordInput>(
      passwordInput,
      transformer: debounce(
        const Duration(milliseconds: 200),
      ),
    );
    on<JoinPasswordAgainInput>(
      passwordAgainInput,
      transformer: debounce(
        const Duration(milliseconds: 100),
      ),
    );
    on<JoinPhoneNumberCancel>(phoneNumberCancel);
    on<JoinPasswordCancel>(passwordCancel);
    on<JoinChangeCountryCode>(changeCountryCode);
    on<JoinBottomButtonClick>(clickNextButton);
    on<JoinPasswordAgainCancel>(passwordAgainCancel);
  }

  FutureOr<void> init(JoinInit event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode ?? state.countryCode,
        countryName: event.countryName ?? state.countryName,
      ),
    );
  }

  FutureOr<void> phoneNumberInput(JoinPhoneNumberInput event, Emitter<JoinState> emit) {
    ChipmunkLogger.debug("state: ${state.toString()}, event: ${event.phoneNumber}");
    emit(
      state.copyWith(
        phoneNumber: event.phoneNumber,
        isButtonEnabled: _isButtonEnabled(
          phoneNumber: event.phoneNumber,
          password: state.password,
          passwordAgain: state.passwordAgain,
        ),
      ),
    );
  }

  FutureOr<void> phoneNumberCancel(JoinPhoneNumberCancel event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        phoneNumber: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> changeCountryCode(JoinChangeCountryCode event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        countryCode: event.countryCode,
        countryName: event.countryName,
      ),
    );
  }

  FutureOr<void> passwordInput(JoinPasswordInput event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        password: event.password,
        isButtonEnabled: _isButtonEnabled(
          phoneNumber: state.phoneNumber,
          password: event.password,
          passwordAgain: state.passwordAgain,
        ),
      ),
    );
  }

  FutureOr<void> passwordCancel(JoinPasswordCancel event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        password: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> passwordAgainCancel(JoinPasswordAgainCancel event, Emitter<JoinState> emit) {
    emit(
      state.copyWith(
        passwordAgain: "",
        isButtonEnabled: false,
      ),
    );
  }

  FutureOr<void> passwordAgainInput(JoinPasswordAgainInput event, Emitter<JoinState> emit) {
    ChipmunkLogger.debug("state: ${state.toString()}");
    emit(
      state.copyWith(
        passwordAgain: event.password,
        isButtonEnabled: _isButtonEnabled(
          phoneNumber: state.phoneNumber,
          password: state.password,
          passwordAgain: event.password,
        ),
      ),
    );
  }

  FutureOr<void> clickNextButton(JoinBottomButtonClick event, Emitter<JoinState> emit) async {
    String phoneNumber = state.phoneNumber;
    String countryCode = state.countryCode;
    String internationalPhoneNumber = phoneNumber.replaceFirst("0", countryCode);
    await authRepository
        .signUp(
          phoneNumber: internationalPhoneNumber,
          password: state.password,
        )
        .then(
          (value) => value.fold(
            (l) => produceSideEffect(JoinError(l)),
            (isSignUp) {
              produceSideEffect(
                JoinLandingScreen(
                  Routes.smsCertifyRoute,
                  phoneNumber: internationalPhoneNumber,
                ),
              );
            },
          ),
        );
  }

  bool _isButtonEnabled({
    required String phoneNumber,
    required String password,
    required String passwordAgain,
  }) =>
      ChipmunkValidator.isValidPhoneNumber(phoneNumber) && password.isNotEmpty && password == passwordAgain;
}
