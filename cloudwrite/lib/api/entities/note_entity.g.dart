// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteEntity _$NoteEntityFromJson(Map<String, dynamic> json) {
  return NoteEntity(
    id: json['_id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    username: json['username'] as String,
    isArchived: json['isArchived'] as bool,
    isPrivate: json['isPrivate'] as bool,
  );
}

Map<String, dynamic> _$NoteEntityToJson(NoteEntity instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'username': instance.username,
      'isArchived': instance.isArchived,
      'isPrivate': instance.isPrivate,
    };
