import 'package:cloudwrite/app/form_fields/email.dart';
import 'package:cloudwrite/app/form_fields/password.dart';
import 'package:cloudwrite/app/form_fields/username.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.formState = FormzStatus.pure,
    this.email = const Email.pure(),
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  get isFormValid =>
      !email.pure &&
      email.error == null &&
      !username.pure &&
      username.error == null &&
      !password.pure &&
      password.error == null;

  final FormzStatus formState;
  final Email email;
  final Username username;
  final Password password;

  RegisterState copyWith({
    FormzStatus status,
    Email email,
    Username username,
    Password password,
  }) {
    return RegisterState(
      formState: status ?? this.formState,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props => [formState, email, username, password];
}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure({@required this.message});

  @override
  List<Object> get props => [message];
}
