import 'package:cloudwrite/app/form_fields/email.dart';
import 'package:cloudwrite/app/form_fields/password.dart';
import 'package:cloudwrite/app/form_fields/username.dart';
import 'package:cloudwrite/app/pages/register/bloc/register_bloc.dart';
import 'package:cloudwrite/app/pages/register/bloc/register_event.dart';
import 'package:cloudwrite/app/pages/register/bloc/register_state.dart';
import 'package:cloudwrite/core/base_page_container.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/global.dart';
import 'package:formz/formz.dart';

class RegisterPage extends StatelessWidget {
  final navigation = ServiceResolver.get<FluroRouter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(translate("common_registration")),
        ),
        body: BasePageContainer(
            child: BlocProvider(
                create: (context) {
                  return RegisterBloc();
                },
                child: _registerForm())));
  }

  Widget _registerForm() {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
      if (state.formState.isSubmissionInProgress) {
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 500),
            // ignore: missing_return
            pageBuilder: (context, animation1, animation2) {},
            transitionBuilder: (context, a1, a2, child) {
              return Opacity(
                  opacity: a1.value,
                  child: Stack(
                    children: [
                      Transform.scale(
                          scale: 4.0,
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: RadialGradient(colors: <Color>[
                                    Colors.cyan,
                                    Colors.transparent
                                  ])))),
                      Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Padding(padding: EdgeInsets.all(5)),
                              Text("${translate("register_registration")}...",
                                  style: TextStyle(
                                      color: Colors.white, decorationThickness: 5)),
                            ],
                          )),
                    ],
                  ));
            });
      } else if (state.formState.isSubmissionSuccess) {
        navigation.navigateTo(context, "/",
            clearStack: true);
        navigation.navigateTo(context, "/login");
      } else if (state is RegisterFailure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade300,
            content: Text(state.message)));
      }
    }, child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return Column(
        children: [
          Padding(padding: EdgeInsets.all(12)),
          _email(),
          Padding(padding: EdgeInsets.all(12)),
          _username(),
          Padding(padding: EdgeInsets.all(12)),
          _password(),
          Padding(padding: EdgeInsets.all(12)),
          Row(children: [Expanded(child: _registerButton())]),
        ],
      );
    }));
  }

  Widget _email() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('register_form_email_text_input'),
          onChanged: (email) =>
              context.read<RegisterBloc>().add(RegisterEmailChanged(email)),
          decoration: InputDecoration(
              labelText: translate("common_email"),
              errorText: !state.email.invalid
                  ? null
                  : state.email.error == EmailValidationError.empty
                      ? translate("validation_error_general_please_fill")
                      : state.email.error == EmailValidationError.format
                          ? translate("validation_error_general_please_fill")
                          : null),
        );
      },
    );
  }

  Widget _username() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('register_form_username_text_input'),
          onChanged: (username) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username)),
          decoration: InputDecoration(
              labelText: translate("common_username"),
              errorText: !state.username.invalid
                  ? null
                  : state.username.error == UsernameValidationError.empty
                      ? translate("validation_error_general_please_fill")
                      : state.username.error == UsernameValidationError.length
                          ? translate("validation_error_general_please_fill")
                          : null),
        );
      },
    );
  }

  Widget _password() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('register_form_password_text_input'),
          onChanged: (password) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
              labelText: translate("common_password"),
              errorText: !state.password.invalid
                  ? null
                  : state.password.error == PasswordValidationError.empty
                      ? translate("validation_error_general_please_fill")
                      : state.password.error == PasswordValidationError.length
                          ? translate("validation_error_general_please_fill")
                          : null),
        );
      },
    );
  }

  Widget _registerButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        key: const Key('register_form_submit_button'),
        child: Text(translate("common_register")),
        onPressed: state.formState.isValidated
            ? () {
                context.read<RegisterBloc>().add(RegisterChanged());
              }
            : null,
      );
    });
  }
}
