import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_state.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NotesEvent extends Equatable {}

class Fetch extends NotesEvent {
  final NotesFilters filters;

  Fetch({this.filters = const NotesFilters()});

  @override
  List<Object> get props => [filters];
}

class AddNewNote extends NotesEvent {
  final NoteEntity newNote;

  AddNewNote({@required this.newNote});

  @override
  List<Object> get props => [newNote];
}
