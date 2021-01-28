import 'package:cloudwrite/api/entities/note_entity.dart';
import 'package:cloudwrite/app/pages/home/home_page.dart';
import 'package:cloudwrite/app/pages/login/login_page.dart';
import 'package:cloudwrite/app/pages/note_details/note_details_page.dart';
import 'package:cloudwrite/app/pages/notes/notes_page.dart';
import 'package:cloudwrite/app/pages/register/register_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routing {
  static final _homeHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          HomePage());
  static final _loginHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          LoginPage());
  static final _registerHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          RegisterPage());
  static final _notesHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          NotesPage());
  static final _noteDetails = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) =>
          NoteDetailsPage(note: context.settings.arguments as NoteEntity));

  static void configureRoutes(FluroRouter router) {
    router.define('/',
        handler: _homeHandler, transitionType: TransitionType.fadeIn);
    router.define('/login',
        handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define('/register',
        handler: _registerHandler, transitionType: TransitionType.fadeIn);
    router.define('/notes',
        handler: _notesHandler, transitionType: TransitionType.fadeIn);
    router.define('/note',
        handler: _noteDetails, transitionType: TransitionType.fadeIn);
  }
}
