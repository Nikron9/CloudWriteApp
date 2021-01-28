import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloudwrite/app/form_fields/password.dart';
import 'package:cloudwrite/app/form_fields/username.dart';
import 'package:cloudwrite/app/pages/auth/auth_service.dart';
import 'package:cloudwrite/app/pages/login/bloc/login_event.dart';
import 'package:cloudwrite/app/pages/login/bloc/login_state.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:formz/formz.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(
    LoginUsernameChanged event,
    LoginState state,
  ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(
    LoginPasswordChanged event,
    LoginState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    if (state.formState.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await Future.delayed(Duration(seconds: 2));

        var result = await ServiceResolver.get<AuthService>()
            .signIn(state.username.value, state.password.value);

        if (!result.key.hasException) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else {
          yield LoginFailure(
              message: result.key.exception.graphqlErrors.first.message);
        }
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
