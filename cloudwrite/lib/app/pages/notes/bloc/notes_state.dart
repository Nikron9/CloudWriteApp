import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {
  final List<NoteEntity> notes;
  final NotesFilters filters;

  NotesState({this.notes = const [], this.filters = const NotesFilters()});
}

class NotesInit extends NotesState {
  NotesInit() : super();

  @override
  List<Object> get props => [];
}

class NotesLoading extends NotesState {
  NotesLoading(filters) : super(filters: filters);

  @override
  List<Object> get props => [];
}

class NotesError extends NotesState {
  final String message;

  NotesError({this.message}) : super();

  @override
  List<Object> get props => [];
}

class NotesLoaded extends NotesState {
  NotesLoaded({notes, filters}) : super(notes: notes, filters: filters);

  NotesLoaded copyWith({List<NoteEntity> notes}) {
    return NotesLoaded(
        filters: filters ?? this.filters, notes: notes ?? this.notes);
  }

  @override
  List<Object> get props => [];
}

class NotesFilters {
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
}
