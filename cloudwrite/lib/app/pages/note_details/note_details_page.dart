import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/api/entities/user_entity.dart';
import 'package:cloudwrite/app/form_fields/note_content.dart';
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

            return BlocProvider(create: (context) {
              return NoteDetailsBloc(NoteDetailsState(
                  mode: mode,
                  title: NoteTitle.dirty(note.title),
                  content: NoteContent.dirty(note.content)));
            }, child: Builder(builder: (context) {
              return Scaffold(
                  appBar: AppBar(
                      title:
                          Text(note.id != null ? "Note details" : "New note")),
                  body: _noteDetailsForm(),
                  floatingActionButton: Visibility(
                      visible: context.read<NoteDetailsBloc>().state.mode !=
                          NoteDetailsMode.Read,
                      child: _floatingButtons(context)));
            }));
          }
        });
  }

  Widget _noteDetailsForm() {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
        builder: (context, state) {
      return Column(children: [
        _isPrivate(),
        BasePageContainer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 15)),
            _title(),
            Padding(padding: EdgeInsets.only(top: 10, bottom: 10)),
            _content(),
          ],
        ))
      ]);
    });
  }

  Widget _title() {
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

  Widget _content() {
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

  Widget _isPrivate() {
    return BlocBuilder<NoteDetailsBloc, NoteDetailsState>(
      buildWhen: (previous, current) => previous.isPrivate != current.isPrivate,
      builder: (context, state) {
        return ListTileSwitch(
            enabled: state.mode != NoteDetailsMode.Read,
            title: Text("Private"),
            switchActiveColor: Colors.cyan,
            value: state.isPrivate.value,
            onChanged: !note.isArchived
                ? (content) {
                    context
                        .read<NoteDetailsBloc>()
                        .add(NoteDetailsIsPrivateChanged(content));
                  }
                : (content) {});
      },
    );
  }

  Widget _floatingButtons(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
          padding: EdgeInsets.only(right: 5),
          child: Visibility(
              visible: context.read<NoteDetailsBloc>().state.mode !=
                  NoteDetailsMode.Read,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Archive"),
                FloatingActionButton(
                    heroTag: "1",
                    mini: true,
                    child: Icon(Icons.archive),
                    onPressed: () {
                      context.read<NoteDetailsBloc>().add(NoteDetailsSaveEvent(
                          note.copyWith(isArchived: true)));
                    }),
              ]))),
      Padding(padding: EdgeInsets.only(top: 10)),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Text("Save"),
        Padding(padding: EdgeInsets.only(right: 10)),
        FloatingActionButton(
            heroTag: "2",
            child: Icon(Icons.save_sharp),
            onPressed: () {
              context.read<NoteDetailsBloc>().add(NoteDetailsSaveEvent(note));
            })
      ])
    ]);
  }
}
