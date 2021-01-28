import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloudwrite/api/client.dart';
import 'package:cloudwrite/app/form_fields/email.dart';
import 'package:cloudwrite/app/form_fields/password.dart';
import 'package:cloudwrite/app/form_fields/username.dart';
import 'package:cloudwrite/app/pages/register/bloc/register_event.dart';
import 'package:cloudwrite/app/pages/register/bloc/register_state.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:formz/formz.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is RegisterUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is RegisterPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is RegisterChanged) {
      yield* _mapRegisterSubmittedToState(event, state);
    }
  }

  RegisterState _mapEmailChangedToState(
    RegisterEmailChanged event,
    RegisterState state,
  ) {
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.email, email]),
    );
  }

  RegisterState _mapUsernameChangedToState(
    RegisterUsernameChanged event,
    RegisterState state,
  ) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.username, username]),
    );
  }

  RegisterState _mapPasswordChangedToState(
    RegisterPasswordChanged event,
    RegisterState state,
  ) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([state.password, password]),
    );
  }

  Stream<RegisterState> _mapRegisterSubmittedToState(
    RegisterChanged event,
    RegisterState state,
  ) async* {
    if (state.formState.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        await Future.delayed(Duration(seconds: 2));

        var result = await ServiceResolver.get<GraphQLService>().signUp(
            state.email.value, state.username.value, state.password.value);

        if (!result.hasException) {
          yield state.copyWith(status: FormzStatus.submissionSuccess);
        } else {
          yield RegisterFailure(
              message: result.exception.graphqlErrors.first.message);
        }
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
