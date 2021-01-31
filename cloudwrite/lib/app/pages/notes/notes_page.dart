import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_bloc.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_event.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_state.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_bloc.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_event.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_state.dart';
import 'package:cloudwrite/core/exit_dialog.dart';
import 'package:cloudwrite/extensions.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_translate/global.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class NotesPage extends StatelessWidget {
  final navigation = ServiceResolver.get<FluroRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => BlocProvider(
            create: (context) => NotesBloc(NotesInit()),
            child: Scaffold(
                appBar: AppBar(
                  title: Text(translate("CloudWrite")),
                  actions: [
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(UserLoggedOut());
                          navigation.navigateTo(context, "/", clearStack: true);
                        })
                  ],
                ),
                body: _notesMainContainer(context),
                floatingActionButton: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) => FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => navigateToNote(context),
                  ),
                ))));
  }

  Future navigateToNote(BuildContext context) async {
    NoteEntity result = await navigation.navigateTo(context, "/note",
        routeSettings:
            RouteSettings(arguments: NoteEntity().copyWith(isArchived: false)));

    context.read<NotesBloc>().add(AddNewNote(newNote: result));
  }

  Widget _notesMainContainer(BuildContext context) {
    return WillPopScope(
        child: Container(
            child: BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) => Column(children: [
                      _searchBar(context, state),
                      _filters(state, context),
                      _notesList()
                    ]))),
        onWillPop: exitDialog(context));
  }

  Widget _searchBar(BuildContext context, NotesState state) {
    return TextField(
      decoration: InputDecoration(
          hintText: "${translate("common_search")}...",
          prefixIcon: Icon(Icons.search)),
      maxLines: 1,
      onChanged: (value) => EasyDebounce.debounce(
          "search_debounce",
          Duration(milliseconds: 500),
          () => context
              .read<NotesBloc>()
              .add(Fetch(filters: state.filters.copyWith(search: value)))),
    );
  }

  Widget _filters(NotesState state, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(children: [
          Tags(
              alignment: WrapAlignment.start,
              itemCount: 2,
              itemBuilder: (int index) => ItemTags(
                    index: index,
                    title: index == 0
                        ? translate("notes_list_only_mine_filter")
                        : translate("notes_list_with_archived_filter"),
                    active: index == 0
                        ? state.filters.onlyMine
                        : state.filters.withArchived,
                    activeColor: Colors.cyanAccent,
                    color: Colors.cyan.shade900,
                    textActiveColor: Colors.black,
                    textColor: Colors.white,
                    onPressed: (item) {
                      if (index == 0) {
                        context.read<NotesBloc>().add(Fetch(
                            filters: state.filters
                                .copyWith(onlyMine: !state.filters.onlyMine)));
                      } else {
                        context.read<NotesBloc>().add(Fetch(
                            filters: state.filters.copyWith(
                                withArchived: !state.filters.withArchived)));
                      }
                    },
                  ))
        ]));
  }

  Widget _notesList() {
    return BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return Padding(
                  padding: EdgeInsets.all(20), child: Text("List is empty"));
            } else {
              return Expanded(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<NotesBloc>().state.notes.clear();
                        context
                            .read<NotesBloc>()
                            .add(Fetch(filters: state.filters));

                        return context
                            .read<NotesBloc>()
                            .firstWhere((element) => element is Fetch);
                      },
                      child: WaterfallFlow.builder(
                          primary: true,
                          shrinkWrap: true,
                          itemCount: state.notes.length,
                          gridDelegate:
                              SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: context.isPortrait() ? 2 : 3),
                          itemBuilder: (context, int index) {
                            return _noteListItem(context, state, index);
                          })));
            }
          } else if (state is NotesInit) {
            context.read<NotesBloc>().add(Fetch());
            return Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator());
          } else if (state is NotesError) {
            return Padding(
                padding: EdgeInsets.all(20), child: Text(state.message));
          } else {
            return Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator());
          }
        });
  }

  Widget _noteListItem(BuildContext context, NotesLoaded state, int index) {
    return GestureDetector(
        onTap: () {
          navigation.navigateTo(context, "/note",
              routeSettings: RouteSettings(arguments: state.notes[index]));
        },
        child: Card(
            elevation: 5,
            shadowColor: Colors.cyan.shade700,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(state.notes[index].title,
                                style: TextStyle(
                                    color: Colors.cyan.shade900,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis),
                            if (state.notes[index].isArchived)
                              Icon(Icons.archive)
                          ]),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(
                        state.notes[index].content,
                        style: TextStyle(fontSize: 14),
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      Align(
                        child: Text(state.notes[index].username,
                            style: TextStyle(color: Colors.cyan.shade900)),
                        alignment: AlignmentDirectional.bottomEnd,
                      )
                    ]))));
  }
}
