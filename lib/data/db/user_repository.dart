import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/chipmunk_error.dart';
import 'package:supabase/supabase.dart';

class UserRepository {
  final SupabaseClient _client;

  final tableName = "users";

  UserRepository(this._client);

  // 이미 가입된 이메일인지 확인.
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      final List<dynamic> response = await _client.from(tableName).select('email').eq('email', email);
      ChipmunkLogger.debug('IsEmailAlreadyRegistered:: ${response}');
      return response.isNotEmpty;
    } on PostgrestException catch (e) {
      throw AuthFailure(
        errorMessage: e.message,
      );
    }
  }

  Future<void> signUp(String email) async {
    try {
      await _client.from(tableName).insert({'email': email});
    } on PostgrestException catch (e) {
      throw AuthFailure(
        errorMessage: e.message,
      );
    }
  }
}
