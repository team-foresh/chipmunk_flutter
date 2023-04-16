import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_code_state.freezed.dart';

@freezed
class CountryCodeState with _$CountryCodeState {
  factory CountryCodeState({
    required List<CountryCode> countries,
    required CountryCode selected,
  }) = _CountryCodeState;

  factory CountryCodeState.initial() => CountryCodeState(
        countries: List.empty(),
        selected: const CountryCode(
          code: "+82",
          name: "대한민국",
        ),
      );
}

class CountryCode extends Equatable {
  final String code;
  final String name;

  const CountryCode({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}
