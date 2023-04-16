import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SmsVerifySideEffect extends Equatable {}

class SmsVerifyError extends SmsVerifySideEffect {
  final ChipmunkFailure error;

  SmsVerifyError(this.error);

  @override
  List<Object?> get props => [];
}

class SmsVerifyMovePage extends SmsVerifySideEffect {
  final String route;

  SmsVerifyMovePage(this.route);

  @override
  List<Object?> get props => [];
}

class SmsVerifyOpenSetting extends SmsVerifySideEffect {
  SmsVerifyOpenSetting();

  @override
  List<Object?> get props => [];
}

class SmsVerifyStartListening extends SmsVerifySideEffect {
  SmsVerifyStartListening();

  @override
  List<Object?> get props => [];
}
