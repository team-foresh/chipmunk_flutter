class UserEntity {
  final String phone;
  final String nickname;
  final bool verified;
  final bool agreeTerms;

  UserEntity({
    required this.phone,
    required this.nickname,
    required this.verified,
    required this.agreeTerms,
  });
}
