import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chipmunk_main_error_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class ChipmunkErrorResponse {
  @JsonKey(name: 'errorCode')
  int? code; // 10007
  @JsonKey(name: 'type')
  String? type; // preAuthenticationRequest
  @JsonKey(name: 'message')
  String? message; // 서버에서 주는 에러메세지.

  ChipmunkErrorResponse({@required this.code, @required this.message, @required this.type});

  factory ChipmunkErrorResponse.fromJson(Map<String, dynamic> json) => _$ChipmunkErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChipmunkErrorResponseToJson(this);
}
