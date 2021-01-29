import 'package:cloudwrite/api/client.dart';
import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/form_fields/note_content.dart';
import 'package:cloudwrite/app/form_fields/note_is_private.dart';
import 'package:cloudwrite/app/form_fields/note_title.dart';
import 'package:cloudwrite/app/pages/note_details/bloc/note_details_event.dart';
import 'package:cloudwrite/app/pages/note_details/bloc/note_details_state.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class NoteDetailsBloc extends Bloc<NoteDetailsEvent, NoteDetailsState> {
  NoteDetailsBloc(NoteDetailsState initialState) : super(initialState);

  @override
  Stream<NoteDetailsState> mapEventToState(NoteDetailsEvent event) async* {
    if (event is NoteDetailsTitleChanged) {
      yield _mapTitleChangedToState(event, state);
    } else if (event is NoteDetailsContentChanged) {
      yield _mapContentChangedToState(event, state);
    } else if (event is NoteDetailsIsPrivateChanged) {
      yield _mapIsPrivateChangedToState(event, state);
    } else if (event is NoteDetailsSaveEvent) {
      yield* _mapEventToSaveSubmittedState(event, state);
    }
  }

  NoteDetailsState _mapTitleChangedToState(
    NoteDetailsTitleChanged event,
    NoteDetailsState state,
  ) {
    final title = NoteTitle.dirty(event.title);
    return state.copyWith(title: title);
  }

  NoteDetailsState _mapContentChangedToState(
    NoteDetailsContentChanged event,
    NoteDetailsState state,
  ) {
    final content = NoteContent.dirty(event.content);
    return state.copyWith(content: content);
  }

  NoteDetailsState _mapIsPrivateChangedToState(
      NoteDetailsIsPrivateChanged event, NoteDetailsState state) {
    final isPrivate = NoteIsPrivate.dirty(event.isPrivate);
    return state.copyWith(
      isPrivate: isPrivate,
    );
  }

  Stream<NoteDetailsState> _mapEventToSaveSubmittedState(
    NoteDetailsSaveEvent event,
    NoteDetailsState state,
  ) async* {
    if (state.isFormValid) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await Future.delayed(Duration(seconds: 2));

        var oldEntity = event.oldNoteEntity.copyWith(
            title: state.title.value,
            content: state.content.value,
            isPrivate: state.isPrivate.value);

        var result = state.mode == NoteDetailsMode.Create
            ? await ServiceResolver.get<GraphQLService>().createNote(oldEntity)
            : await ServiceResolver.get<GraphQLService>().updateNote(oldEntity);

        var newNote = NoteEntity.fromJson(result.data[
            state.mode == NoteDetailsMode.Create ? "addNote" : "updateNote"]);

        if (!result.hasException) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else {
          yield null;
        }
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
