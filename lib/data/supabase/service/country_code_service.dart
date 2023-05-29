import 'package:chipmunk_flutter/data/supabase/response/country_code_response.dart';
import 'package:chipmunk_flutter/data/supabase/service_ext.dart';
import 'package:chipmunk_flutter/domain/supabase/entity/country_code_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountryCodeService {
  final SupabaseClient _client;

  final _tableName = "country_code";

  CountryCodeService(this._client);

  /// 국가 코드 조회.
  Future<List<CountryCodeEntity>> getCountryCodes() async {
    final response = await _client.from(_tableName).select('*').toSelect();
    final countries = response.map((e) => CountryCodeResponse.fromJson(e)).toList();
    return countries;
  }
}
