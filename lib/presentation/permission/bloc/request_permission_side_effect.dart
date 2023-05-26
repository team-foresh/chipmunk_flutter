import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RequestPermissionSideEffect extends Equatable {}

class RequestPermissionError extends RequestPermissionSideEffect {
  final ChipmunkFailure error;

  RequestPermissionError(this.error);

  @override
  List<Object?> get props => [];
}

class RequestPermissionStart extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}


class RequestPermissionFail extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}

class RequestPermissionSuccess extends RequestPermissionSideEffect {
  @override
  List<Object?> get props => [];
}