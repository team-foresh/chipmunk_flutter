import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AgreeTermsSideEffect extends Equatable {}

class AgreeTermsError extends AgreeTermsSideEffect {
  final ChipmunkFailure error;

  AgreeTermsError(this.error);

  @override
  List<Object?> get props => [];
}

class AgreeTermsPop extends AgreeTermsSideEffect {
  final bool flag;

  AgreeTermsPop(this.flag);

  @override
  List<Object?> get props => [];
}
