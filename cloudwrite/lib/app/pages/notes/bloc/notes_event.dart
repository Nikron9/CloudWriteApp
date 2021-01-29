import 'package:cloudwrite/app/pages/notes/bloc/notes_state.dart';
import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {}

class Fetch extends NotesEvent {
  final NotesFilters filters;

  Fetch({this.filters = const NotesFilters()});

  @override
  List<Object> get props => [];
}
