import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NoteDetailsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class NoteDetailsTitleChanged extends NoteDetailsEvent {
  final String title;

  NoteDetailsTitleChanged(this.title);

  @override
  List<Object> get props => [title];
}

class NoteDetailsContentChanged extends NoteDetailsEvent {
  final String content;

  NoteDetailsContentChanged(this.content);

  @override
  List<Object> get props => [content];
}

class NoteDetailsIsPrivateChanged extends NoteDetailsEvent {
  final bool isPrivate;

  NoteDetailsIsPrivateChanged(this.isPrivate);

  @override
  List<Object> get props => [isPrivate];
}

class NoteDetailsSaveEvent extends NoteDetailsEvent {
  final NoteEntity oldNoteEntity;

  NoteDetailsSaveEvent(this.oldNoteEntity);

  @override
  List<Object> get props => [oldNoteEntity];
}
