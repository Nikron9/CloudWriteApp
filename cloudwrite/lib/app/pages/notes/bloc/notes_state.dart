import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {}

class NotesInit extends NotesState {
  @override
  List<Object> get props => [];
}

class NotesError extends NotesState {
  final String message;

  NotesError({this.message});

  @override
  List<Object> get props => [];
}

class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;

  NotesLoaded({this.notes});

  NotesLoaded copyWith({List<NoteEntity> notes}) {
    return NotesLoaded(notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [];
}
