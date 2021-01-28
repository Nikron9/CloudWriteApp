import 'dart:async';

import 'package:cloudwrite/app/pages/auth/auth_service.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_event.dart';
import 'package:cloudwrite/app/pages/auth/bloc/auth_state.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  final AuthService _authService = ServiceResolver.get<AuthService>();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is UserLoggedIn) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is UserLoggedOut) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    try {
      final currentUser = await _authService.getCurrentUser();

      if (currentUser != null && !JwtDecoder.isExpired(currentUser.token)) {
        yield AuthenticationAuthenticated(user: currentUser);
      } else {
        yield AuthenticationNotAuthenticated();
      }
    } catch (e) {
      yield AuthenticationFailure(message: e.toString());
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(
      UserLoggedIn event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(
      UserLoggedOut event) async* {
    await _authService.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
