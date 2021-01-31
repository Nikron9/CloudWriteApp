import 'package:bloc/bloc.dart';
import 'package:cloudwrite/api/client.dart';
import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_event.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_state.dart';
import 'package:cloudwrite/service_resolver.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(NotesState initialState) : super(initialState);

  NotesState get initialState => NotesInit();

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    if (event is AddNewNote) {
      yield* _mapAddNewNoteToState(event, state);
    } else if (event is Fetch) {
      yield* _mapFetchToState(event, state);
    }
  }

  Stream<NotesState> _mapAddNewNoteToState(
    AddNewNote event,
    NotesState state,
  ) async* {
    yield NotesLoaded(notes: List.of(state.notes)..insert(0, event.newNote), filters: state.filters);
  }

  Stream<NotesState> _mapFetchToState(
    Fetch event,
    NotesState state,
  ) async* {
    yield NotesLoading();
    await Future.delayed(Duration(seconds: 1));

    try {
      var result = await ServiceResolver.get<GraphQLService>().fetchNotes(
          event.filters.search,
          event.filters.onlyMine,
          event.filters.withArchived);

      if (!result.hasException) {
        var notes = (result.data["notes"] as List)
            .map((e) => NoteEntity.fromJson(e))
            .toList();

        yield NotesLoaded(notes: notes, filters: event.filters);
      } else {
        yield NotesError(message: result.exception.graphqlErrors.first.message);
      }
    } catch (error) {
      yield NotesError(message: error.toString());
    }
  }
}
