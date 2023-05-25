import 'package:chipmunk_flutter/domain/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable(nullable: false, ignoreUnannotated: false)
class UserResponse extends UserEntity {
  @JsonKey(name: 'phone')
  final String? phone_;
  @JsonKey(name: 'nickname')
  final String? nickname_;
  @JsonKey(name: 'verified')
  final bool? verified_;
  @JsonKey(name: 'agree_terms')
  final bool? agreeTerms_;

  UserResponse({
    this.phone_,
    this.verified_,
    this.nickname_,
    this.agreeTerms_,
  }) : super(
          nickname: nickname_ ?? "",
          phone: phone_ ?? "",
          verified: verified_ ?? false,
          agreeTerms: agreeTerms_ ?? false,
        );

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
