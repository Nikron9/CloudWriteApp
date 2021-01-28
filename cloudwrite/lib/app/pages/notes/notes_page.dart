import 'package:cloudwrite/app/pages/auth/bloc/auth_bloc.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_event.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_state.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_bloc.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_event.dart';
import 'package:cloudwrite/app/pages/notes/bloc/notes_state.dart';
import 'package:cloudwrite/extensions.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_translate/global.dart';

class NotesPage extends StatelessWidget {
  final navigation = ServiceResolver.get<FluroRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            title: Text(translate("CloudWrite")),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthenticationBloc>().add(UserLoggedOut());
                    navigation.navigateTo(context, "/", clearStack: true);
                  })
            ],
          ),
          body: BlocProvider(
              create: (context) {
                return NotesBloc(NotesInit());
              },
              child: _notesList(context)));
    });
  }

  Widget _notesList(BuildContext context) {
    return WillPopScope(child: Container(
        child: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
      if (state is NotesLoaded) {
        return RefreshIndicator(
            onRefresh: () async {
              state.notes.clear();
              context.read<NotesBloc>().add(Fetch());
            },
            child: StaggeredGridView.builder(
                gridDelegate:
                    SliverStaggeredGridDelegateWithFixedCrossAxisCount(
                        staggeredTileCount: state.notes.length,
                        staggeredTileBuilder: (int index) =>
                            StaggeredTile.fit(1),
                        crossAxisCount: context.isPortrait() ? 2 : 3),
                padding: EdgeInsets.all(5),
                itemBuilder: (context, int index) {
                  return GestureDetector(
                      onTap: () {
                        navigation.navigateTo(context, "/note",
                            routeSettings:
                                RouteSettings(arguments: state.notes[index]));
                      },
                      child: Card(
                          elevation: 5,
                          shadowColor: Colors.cyan.shade700,
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.notes[index].title,
                                        style: TextStyle(
                                            color: Colors.cyan.shade900,
                                            fontSize: 18,
                                            decorationThickness: 10),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(
                                      state.notes[index].content,
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 10,
                                      overflow: TextOverflow.fade,
                                    )
                                  ]))));
                }));
      } else if (state is NotesInit) {
        context.read<NotesBloc>().add(Fetch());
        return CircularProgressIndicator();
      } else if (state is NotesError) {
        return Text(state.message);
      } else {
        return CircularProgressIndicator();
      }
    })), onWillPop: () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Exit"),
              content: Text("Are you sure you want to exit?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("YES"),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                FlatButton(
                  child: Text("NO"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
      return Future.value(true);
    });
  }
}
