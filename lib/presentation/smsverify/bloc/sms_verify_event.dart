import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class SmsVerifyEvent extends Equatable {}

class SmsVerifyInit extends SmsVerifyEvent {
  final String phoneNumber;

  SmsVerifyInit({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [];
}
class SmsVerifyInput extends SmsVerifyEvent {
  final String verifyCode;
  final bool auto;

  SmsVerifyInput({
    required this.verifyCode,
    required this.auto,
  });

  @override
  List<Object?> get props => [verifyCode, auto];
}

class SmsVerifyBottomButtonPressed extends SmsVerifyEvent {
  SmsVerifyBottomButtonPressed();

  @override
  List<Object?> get props => [];
}
