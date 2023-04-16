import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/service/user_service.dart';
import 'package:chipmunk_flutter/domain/entity/user_entity.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService,
  });

  // 사용자 찾기.
  Future<ChipmunkResult<UserEntity?>> findUserByPhone({
    required String phoneNumber,
    bool showError = false,
  }) async {
    try {
      final UserEntity? user = await userService.findUserByPhone(phoneNumber);
      return Right(user);
    } on ChipmunkFailure catch (e) {
      ChipmunkLogger.error(
        '[findUserByPhone] - '
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }
}
