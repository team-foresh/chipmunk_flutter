import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:supabase/supabase.dart';

class UserService {
  final SupabaseClient _client;

  final tableName = "users";

  UserService(this._client);

  // 회원가입.
  Future<void> insert(String email) async {
    try {
      await _client.from(tableName).insert({'email': email});
    } on PostgrestException catch (e) {
      throw PostgrestFailure(
        errorMessage: e.message,
        errorCode: e.code,
      );
    }
  }

  // 프로필 이미지 업데이트.
  Future<bool> updateProfile(String path) async {
    try {
      await _client.from(tableName).update(
        {'profile': path},
      ).match(
        {"email": _client.auth.currentUser?.email},
      );
      return true;
    } on PostgrestException catch (e) {
      throw PostgrestFailure(
        errorMessage: e.message,
        errorCode: e.code,
      );
    }
  }
}
