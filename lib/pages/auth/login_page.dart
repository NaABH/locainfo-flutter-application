import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_auth_textfield.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_pressableText.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggingIn) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the entered credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context,
                'There is something wrong with your email or password');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'The email entered is invalid');
          } else if (state.exception is AccountDisabledAuthException) {
            await showErrorDialog(context, 'Your account is blocked');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context,
                'Authentication error. Check your Internet connection and ensure all fields are filled.');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
          ),
          title: Text(
            'Log In',
            style: CustomFontStyles.appBarTitle,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Email Address',
                  style: CustomFontStyles.textFieldLabel,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyAuthTextField(
                  controller: _email,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Password',
                  style: CustomFontStyles.textFieldLabel,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyAuthTextField(
                  controller: _password,
                  hideText: true,
                  hintText: "Enter your password",
                  textInputType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyPressableText(
                          text: 'Forgot Password?',
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthEventForgotPassword());
                          })
                    ],
                  ),
                ),
                MyButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );
                    },
                    text: 'Sign In')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
