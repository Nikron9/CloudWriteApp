import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {
  final List<NoteEntity> notes;
  final NotesFilters filters;

  NotesState({this.notes = const [], this.filters = const NotesFilters()});

  @override
  List<Object> get props => [notes, filters];
}

class NotesInit extends NotesState {
  NotesInit() : super();
}

class NotesLoading extends NotesState {
  NotesLoading() : super();
}

class NotesError extends NotesState {
  final String message;

  NotesError({this.message}) : super();

  @override
  List<Object> get props => [message];
}

class NotesLoaded extends NotesState {
  NotesLoaded({notes, filters}) : super(notes: notes, filters: filters);

  NotesLoaded copyWith({List<NoteEntity> notes}) {
    return NotesLoaded(
        filters: filters ?? this.filters, notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [notes, filters];
}

class NotesFilters extends Equatable{
  final String search;
  final bool onlyMine;
  final bool withArchived;

  NotesFilters copyWith({String search, bool onlyMine, bool withArchived}) {
    return NotesFilters(
        search: search ?? this.search,
        onlyMine: onlyMine ?? this.onlyMine,
        withArchived: withArchived ?? this.withArchived);
  }

  const NotesFilters(
      {this.search = "", this.onlyMine = true, this.withArchived = false});

  @override
  List<Object> get props => [search, onlyMine, withArchived];
}
