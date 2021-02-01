import 'package:cloudwrite/app/form_fields/password.dart';
import 'package:cloudwrite/app/form_fields/username.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

class LoginState extends Equatable {
  const LoginState({
    this.formState = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  get isFormValid =>
      !username.pure &&
      username.error == null &&
      !password.pure &&
      password.error == null;

  final FormzStatus formState;
  final Username username;
  final Password password;

  LoginState copyWith({
    FormzStatus status,
    Username username,
    Password password,
  }) {
    return LoginState(
      formState: status ?? this.formState,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [formState, username, password];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
