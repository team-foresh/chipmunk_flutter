import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CountryCodeSideEffect extends Equatable {}

class CountryCodeError extends CountryCodeSideEffect {
  final ChipmunkFailure error;

  CountryCodeError(this.error);

  @override
  List<Object?> get props => [];
}

class CountryCodeScrollSelected extends CountryCodeSideEffect {
  final int index;

  CountryCodeScrollSelected(this.index);

  @override
  List<Object?> get props => [];
}
