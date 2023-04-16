import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhoneNumberSideEffect extends Equatable {}

class PhoneNumberError extends PhoneNumberSideEffect {
  final ChipmunkFailure error;

  PhoneNumberError(this.error);

  @override
  List<Object?> get props => [];
}

class PhoneNumberLandingScreen extends PhoneNumberSideEffect {
  final String landingRoute;
  final String phoneNumber;

  PhoneNumberLandingScreen(
    this.landingRoute, {
    this.phoneNumber = "",
  });

  @override
  List<Object?> get props => [];
}
