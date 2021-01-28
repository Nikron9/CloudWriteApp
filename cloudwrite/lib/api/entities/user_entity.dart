import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable(nullable: false)
class UserEntity {
  @JsonKey(name: "_id")
  final String id;
  final String username;
  final String email;
  final String token;

  UserEntity({this.id, this.username, this.email, this.token});

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
