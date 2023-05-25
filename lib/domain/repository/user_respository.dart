import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/service/user_service.dart';
import 'package:chipmunk_flutter/domain/entity/agree_terms_entity.dart';
import 'package:chipmunk_flutter/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(
    this._userService,
  );

  // 사용자 찾기.
  Future<ChipmunkResult<UserEntity?>> findUserByPhone(phoneNumber) async {
    try {
      final UserEntity? user = await _userService.findUserByPhone(phoneNumber);
      return Right(user);
    } on ChipmunkFailure catch (e) {
      ChipmunkLogger.error(
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }
}
