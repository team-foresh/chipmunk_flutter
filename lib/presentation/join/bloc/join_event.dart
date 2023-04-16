import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class JoinEvent extends Equatable {}

class JoinInit extends JoinEvent {
  final String? countryCode;
  final String? countryName;

  JoinInit(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}

class JoinPhoneNumberInput extends JoinEvent {
  final String phoneNumber;

  JoinPhoneNumberInput(this.phoneNumber);

  @override
  List<Object?> get props => [];
}

class JoinPasswordInput extends JoinEvent {
  final String password;

  JoinPasswordInput(this.password);

  @override
  List<Object?> get props => [];
}

class JoinPasswordAgainInput extends JoinEvent {
  final String password;

  JoinPasswordAgainInput(this.password);

  @override
  List<Object?> get props => [];
}

class JoinPhoneNumberCancel extends JoinEvent {
  @override
  List<Object?> get props => [];
}

class JoinPasswordCancel extends JoinEvent {
  JoinPasswordCancel();

  @override
  List<Object?> get props => [];
}

class JoinPasswordAgainCancel extends JoinEvent {
  JoinPasswordAgainCancel();

  @override
  List<Object?> get props => [];
}

class JoinBottomButtonClick extends JoinEvent {
  @override
  List<Object?> get props => [];
}

class JoinChangeCountryCode extends JoinEvent {
  final String countryCode;
  final String countryName;

  JoinChangeCountryCode(this.countryCode, this.countryName);

  @override
  List<Object?> get props => [];
}
