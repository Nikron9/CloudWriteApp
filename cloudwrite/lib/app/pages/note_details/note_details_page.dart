import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/api/entities/user_entity.dart';
import 'package:cloudwrite/app/form_fields/note_content.dart';
import 'package:cloudwrite/app/form_fields/note_is_private.dart';
import 'package:cloudwrite/app/form_fields/note_title.dart';
import 'package:cloudwrite/app/pages/auth/auth_service.dart';
import 'package:cloudwrite/app/pages/note_details/bloc/note_details_bloc.dart';
import 'package:cloudwrite/app/pages/note_details/bloc/note_details_event.dart';
import 'package:cloudwrite/app/pages/note_details/bloc/note_details_state.dart';
import 'package:cloudwrite/core/base_page_container.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/global.dart';
import 'package:formz/formz.dart';
import 'package:list_tile_switch/list_tile_switch.dart';

class NoteDetailsPage extends StatelessWidget {
  final navigation = ServiceResolver.get<FluroRouter>();

  final NoteEntity note;

  NoteDetailsPage({@required this.note});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ServiceResolver.get<AuthService>().getCurrentUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var mode = note.id == null
                ? NoteDetailsMode.Create
                : (snapshot.requireData as UserEntity).username !=
                            note?.username ||
                        note.isArchived
                    ? NoteDetailsMode.Read
                    : NoteDetailsMode.Edit;

            return BlocProvider(
                create: (context) => NoteDetailsBloc(NoteDetailsState(
                    mode: mode,
                    title: note.title != null
                        ? NoteTitle.dirty(note.title)
                        : NoteTitle.pure(),
                    content: note.content != null
                        ? NoteContent.dirty(note.content)
                        : NoteContent.pure(),
                    isPrivate: note.isPrivate != null
                        ? NoteIsPrivate.dirty(note.isPrivate)
                        : NoteIsPrivate.pure())),
                child: Builder(
                    builder: (context) => Scaffold(
                        appBar: AppBar(
                            title: Text(note.id != null
                                ? translate("note_details_create")
                                : translate("note_details_edit"))),
                        body: _noteDetailsForm(),
                        floatingActionButton: _floatingButtons(context))));
          }
        });
  }

  Widget _noteDetailsForm() {
    return BlocListener<NoteDetailsBloc, NoteDetailsState>(
        listener: (context, state) {
      if (state is NoteDetailsSubmitSuccess) {
        navigation.pop(context, state.newNote);
        Scaffold.of(context)..showSnackBar(SnackBar(
            backgroundColor: Colors.green.shade300,
            content: Text("Note created")));
      } else if (state is NoteDetailsSubmitFailure) {
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade300,
            content: Text(state.message)));
      }
    }, child: BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
            builder: (context, state) {
      if (state.formState.isSubmissionInProgress) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(children: [
          _isPrivateField(),
          BasePageContainer(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 15)),
              _titleField(),
              Padding(padding: EdgeInsets.only(top: 10)),
              _contentField(),
            ],
          ))
        ]);
      }
    }));
  }

  Widget _titleField() {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextFormField(
          enabled: state.mode != NoteDetailsMode.Read,
          maxLength: 50,
          maxLines: null,
          key: const Key('note_details_form_title_text_input'),
          initialValue: note.title,
          onChanged: (title) => context
              .read<NoteDetailsBloc>()
              .add(NoteDetailsTitleChanged(title)),
          decoration: InputDecoration(
              disabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(),
              labelText: translate("common_title"),
              errorText: !state.title.invalid
                  ? null
                  : state.title.error == NoteTitleValidationError.empty
                      ? translate("validation_error_general_please_fill")
                      : null),
        );
      },
    );
  }

  Widget _contentField() {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
      buildWhen: (previous, current) => previous.content != current.content,
      builder: (context, state) {
        return TextFormField(
            enabled: state.mode != NoteDetailsMode.Read,
            keyboardType: TextInputType.multiline,
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
            initialValue: note.content,
            key: const Key('note_details_form_content_text_input'),
            onChanged: (content) => context
                .read<NoteDetailsBloc>()
                .add(NoteDetailsContentChanged(content)),
            decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                focusedBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(),
                labelText: translate("common_content")));
      },
    );
  }

  Widget _isPrivateField() {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
      buildWhen: (previous, current) => previous.isPrivate != current.isPrivate,
      builder: (context, state) {
        return ListTileSwitch(
            enabled: state.mode != NoteDetailsMode.Read,
            title: Text(translate("note_details_private_field_title")),
            switchActiveColor: Colors.cyan,
            value: state.isPrivate.value ?? false,
            onChanged: !note.isArchived
                ? (content) => context
                    .read<NoteDetailsBloc>()
                    .add(NoteDetailsIsPrivateChanged(content))
                : (content) {});
      },
    );
  }

  Widget _floatingButtons(BuildContext context) {
    return Visibility(
        visible:
            context.read<NoteDetailsBloc>().state.mode != NoteDetailsMode.Read,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Padding(
              padding: EdgeInsets.only(right: 5),
              child: Visibility(
                  visible: context.read<NoteDetailsBloc>().state.mode ==
                      NoteDetailsMode.Edit,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(translate("common_archive")),
                    FloatingActionButton(
                        heroTag: "Archive",
                        mini: true,
                        child: Icon(Icons.archive),
                        onPressed: () => context.read<NoteDetailsBloc>().add(
                            NoteDetailsSaveEvent(
                                note.copyWith(isArchived: true)))),
                  ]))),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(translate("common_save")),
            Padding(padding: EdgeInsets.only(right: 10)),
            FloatingActionButton(
                heroTag: "Save",
                child: Icon(Icons.save_sharp),
                onPressed: () => context
                    .read<NoteDetailsBloc>()
                    .add(NoteDetailsSaveEvent(note)))
          ])
        ]));
  }
}
