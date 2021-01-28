import 'package:json_annotation/json_annotation.dart';

part 'note_entity.g.dart';

@JsonSerializable(nullable: false)
class NoteEntity {
  @JsonKey(name: "_id")
  final String id;
  final String title;
  final String content;
  final String username;
  final bool isArchived;
  final bool isPrivate;

  NoteEntity(
      {this.id,
      this.title,
      this.content,
      this.username,
      this.isArchived,
      this.isPrivate});

  factory NoteEntity.fromJson(Map<String, dynamic> json) =>
      _$NoteEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NoteEntityToJson(this);
}
