import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_auth_textfield.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/utilities/error_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email entered');
          } else if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'The email entered has not been registered');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Unknown error');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventShouldLogIn(),
                  );
            },
          ),
          title: Text(
            'Forgot Password',
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
                  'Please enter your registered email address in the field below. We will send you an email with instructions on how to reset your password.',
                  style: CustomFontStyles.instruction,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(height: 45),
                MyButton(
                    onPressed: () {
                      final email = _email.text;
                      context.read<AuthBloc>().add(
                            AuthEventForgotPassword(email: email),
                          );
                    },
                    text: 'Send Reset Link'),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldLogIn(), // go to login page
                          );
                    },
                    text: 'Go Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
