import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/data/response/user_response.dart';
import 'package:chipmunk_flutter/data/service_ext.dart';
import 'package:chipmunk_flutter/domain/entity/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide UserResponse;

class UserService {
  static const _tag = '[UserService] ';
  final SupabaseClient _client;

  final _tableName = "user";

  UserService(this._client);

  // 회원가입.
  Future<void> insert({
    required String phone,
  }) async {
    try {
      await _client.from(_tableName).insert(UserResponse(phone_: phone).toJson());
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "이미 가입된 회원입니다.",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 사용자 업데이트.
  Future<void> update(
    String phoneNumber, {
    bool? verified,
    String? nickName,
  }) async {
    try {
      UserEntity? user = await findUserByPhone(phoneNumber);
      if (user != null) {
        await _client
            .from(_tableName)
            .update(
              UserResponse(
                phone_: user.phone,
                nickname_: nickName ?? user.nickname,
                verified_: verified ?? user.verified,
              ).toJson(),
            )
            .eq("phone", user.phone);
      }
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "사용자 정보 업데이트 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  //
  // // 프로필 이미지 업데이트.
  // Future<bool> updateProfile(String path) async {
  //   try {
  //     await _client.from(_tableName).update(
  //       {'profile': path},
  //     ).match(
  //       {"email": _client.auth.currentUser?.email},
  //     );
  //     return true;
  //   } on PostgrestException catch (e) {
  //     throw PostgrestFailure(
  //       errorMessage: e.message,
  //       errorCode: e.code,
  //     );
  //   }
  // }

  // 휴대폰 번호로 사용자를 찾음.
  Future<UserEntity?> findUserByPhone(String phone) async {
    try {
      final List<dynamic> response = await _client.from(_tableName).select("*").eq("phone", phone).toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final user = response.map((e) => UserResponse.fromJson(e)).toList();
        return user.single;
      }
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "사용자 검색 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }
}
