import 'package:chipmunk_flutter/core/error/chipmunk_error.dart';
import 'package:chipmunk_flutter/data/service/country_code_service.dart';
import 'package:chipmunk_flutter/domain/entity/country_code_entity.dart';

class CountryCodeRepository {
  final CountryCodeService countryCodeService;

  CountryCodeRepository({
    required this.countryCodeService,
  });

  Future<ChipmunkResult<List<CountryCodeEntity>>> getCountryCode() async {
    final remoteData = await countryCodeService.getCountryCodes().toEntity();
    return remoteData;
  }
}
