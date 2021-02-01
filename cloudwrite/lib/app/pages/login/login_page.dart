import 'dart:ui';

import 'package:cloudwrite/app/pages/login/bloc/login_bloc.dart';
import 'package:cloudwrite/app/pages/login/bloc/login_event.dart';
import 'package:cloudwrite/app/pages/login/bloc/login_state.dart';
import 'package:cloudwrite/core/base_page_container.dart';
import 'package:cloudwrite/extensions.dart';
import 'package:cloudwrite/service_resolver.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/global.dart';
import 'package:formz/formz.dart';

class LoginPage extends StatelessWidget {
  final navigation = ServiceResolver.get<FluroRouter>();

  @override
  Widget build(BuildContext context) {
    return BasePageContainer(
        key: Key("login_screen_key"),
        child: BlocProvider(
            create: (context) {
              return LoginBloc();
            },
            child: _loginForm()));
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
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
                          Text("${translate("login_logging_in")}...",
                              style: TextStyle(
                                  color: Colors.white, decorationThickness: 5)),
                        ],
                      )),
                    ],
                  ));
            });
      }
      if (state is LoginFailure) {
        navigation.pop(context);
        Scaffold.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red.shade300,
            content: Text(state.message)));
      } else if (state.formState.isSubmissionSuccess) {
        navigation.pop(context);
        navigation.navigateTo(context, "/notes", clearStack: true);
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
          padding: EdgeInsets.only(
              top:
                  context.screenHeight() * (context.isPortrait() ? 0.2 : 0.15)),
          child: Column(
            children: [
              _title(context),
              _username(),
              Padding(padding: EdgeInsets.all(12)),
              _password(),
              Padding(padding: EdgeInsets.all(12)),
              Row(children: [Expanded(child: _loginButton())]),
            ],
          ));
    }));
  }

  Align _title(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: context.screenHeight() *
                    (context.isPortrait() ? 0.03 : 0.015)),
            child: Text(
              "CloudWrite",
              style: Theme.of(context).textTheme.headline4,
            )));
  }

  Widget _username() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('login_username_field_key'),
          onChanged: (username) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: translate("common_username"),
            errorText: state.username.invalid
                ? translate("validation_error_general_please_fill")
                : null,
          ),
        );
      },
    );
  }

  Widget _password() {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('login_password_field_key'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: translate("common_password"),
            errorText: state.password.invalid
                ? translate("validation_error_general_please_fill")
                : null,
          ),
        );
      },
    );
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        key: const Key('login_button_key'),
        child: Text(translate("common_login")),
        onPressed: state.isFormValid
            ? () {
                context.read<LoginBloc>().add(const LoginSubmitted());
              }
            : null,
      );
    });
  }
}
