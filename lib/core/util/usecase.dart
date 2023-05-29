import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:dartz/dartz.dart';

typedef ChipmunkResult<T> = Either<ChipmunkFailure, T>;

class Empty {}

abstract class UseCase0<Type> {
  Future<ChipmunkResult<Type>> call();
}

abstract class UseCase1<Type, Params> {
  Future<ChipmunkResult<Type>> call(Params params);
}
