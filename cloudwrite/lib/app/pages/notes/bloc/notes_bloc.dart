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
    yield null;
    if (event is Fetch) {
      try {
        var result = await ServiceResolver.get<GraphQLService>().fetchNotes();

        if (!result.hasException) {
          var notes = (result.data["notes"] as List)
              .map((e) => NoteEntity.fromJson(e))
              .toList();

          yield NotesLoaded(notes: notes);
        } else {
          yield NotesError(
              message: result.exception.graphqlErrors.first.message);
        }
      } catch (error) {
        yield NotesError(message: error.toString());
      }
    }
  }
}
