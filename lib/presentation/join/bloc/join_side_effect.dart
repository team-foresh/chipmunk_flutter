import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class JoinSideEffect extends Equatable {}

class JoinError extends JoinSideEffect {
  final ChipmunkFailure error;

  JoinError(this.error);

  @override
  List<Object?> get props => [];
}

class JoinLandingScreen extends JoinSideEffect {
  final String landingRoute;
  final String phoneNumber;

  JoinLandingScreen(
    this.landingRoute, {
    this.phoneNumber = "",
  });

  @override
  List<Object?> get props => [];
}
