import 'dart:async';

import 'package:chipmunk_flutter/core/util/logger.dart';
import 'package:chipmunk_flutter/data/service/country_code_service.dart';
import 'package:chipmunk_flutter/domain/country_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'country_code.dart';

class CountryCodeBloc extends Bloc<CountryCodeEvent, CountryCodeState>
    with SideEffectBlocMixin<CountryCodeEvent, CountryCodeState, CountryCodeSideEffect> {
  static const tag = "[CountryCodeBloc]";

  final CountryCodeRepository countryCodeRepository;

  CountryCodeBloc({
    required this.countryCodeRepository,
  }) : super(CountryCodeState.initial()) {
    on<CountryCodeInit>(init);
  }

  FutureOr<void> init(CountryCodeInit event, Emitter<CountryCodeState> emit) async {
    await countryCodeRepository.getCountryCode().then(
          (value) => value.fold(
            (l) => produceSideEffect(CountryCodeError(l)),
            (r) {
              ChipmunkLogger.debug(r.toString());
              emit(
                state.copyWith(
                  countries: r.map((e) => CountryCode(code: e.phoneCode, name: e.eName)).toList(),
                  selected: CountryCode(
                    code: event.code ?? state.selected.code,
                    name: event.name ?? state.selected.name,
                  ),
                ),
              );
              produceSideEffect(
                CountryCodeScrollSelected(
                  state.countries.indexWhere((element) => element.code == state.selected.code),
                ),
              );
            },
          ),
        );
  }
}
