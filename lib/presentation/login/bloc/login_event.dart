import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent extends Equatable {}

class LoginInit extends LoginEvent {
  final String? countryCode;
  final String? countryName;

  LoginInit(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}

class LoginPhoneNumberInput extends LoginEvent {
  final String phoneNumber;

  LoginPhoneNumberInput(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class LoginPasswordInput extends LoginEvent {
  final String password;

  LoginPasswordInput(this.password);

  @override
  List<Object?> get props => [];
}

class LoginPhoneNumberCancel extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginPasswordCancel extends LoginEvent {
  LoginPasswordCancel();

  @override
  List<Object?> get props => [];
}

class LoginBottomButtonClick extends LoginEvent {
  @override
  List<Object?> get props => [];
}

class LoginChangeCountryCode extends LoginEvent {
  final String countryCode;
  final String countryName;

  LoginChangeCountryCode(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}
