import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/domain/entity/agree_terms_entity.dart';
import 'package:chipmunk_flutter/presentation/login/bloc/login_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginSideEffect extends Equatable {}

class LoginError extends LoginSideEffect {
  final ChipmunkFailure error;

  LoginError(this.error);

  @override
  List<Object?> get props => [];
}

class LoginLandingRoute extends LoginSideEffect {
  final String landingRoute;
  final String phoneNumber;

  LoginLandingRoute(
    this.landingRoute, {
    this.phoneNumber = "",
  });

  @override
  List<Object?> get props => [];
}

class LoginShowTermsBottomSheet extends LoginSideEffect {
  final List<AgreeTermsEntity> terms;
  final String phoneNumber;

  LoginShowTermsBottomSheet(
    this.terms,
    this.phoneNumber,
  );

  @override
  List<Object?> get props => [];
}

class LoginNextStep extends LoginSideEffect {
  LoginNextStep();

  @override
  List<Object?> get props => [];
}
