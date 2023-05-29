import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/core/util/usecase.dart';
import 'package:chipmunk_flutter/data/supabase/service/country_code_service.dart';
import 'package:chipmunk_flutter/domain/supabase/entity/country_code_entity.dart';
import 'package:dartz/dartz.dart';

class CountryCodeRepository {
  final CountryCodeService countryCodeService;

  CountryCodeRepository({
    required this.countryCodeService,
  });

  Future<ChipmunkResult<List<CountryCodeEntity>>> getCountryCode() async {
    try {
      final remoteData = await countryCodeService.getCountryCodes();
      return Right(remoteData);
    } on ChipmunkFailure catch (e) {
      return Left(e);
    }
  }
}
