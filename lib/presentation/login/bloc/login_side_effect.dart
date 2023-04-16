import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
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

class LoginLandingScreen extends LoginSideEffect {
  final String landingRoute;
  final String phoneNumber;

  LoginLandingScreen(
    this.landingRoute, {
    this.phoneNumber = "",
  });

  @override
  List<Object?> get props => [];
}
