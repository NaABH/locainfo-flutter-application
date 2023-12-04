import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_auth_textfield.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

// page for user to create account
class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is InvalidUsernameAuthException) {
            await showErrorDialog(context,
                'Username should not be empty or start with a number or symbol.');
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, 'This email already in use. Try another one.');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email entered');
          } else if (state.exception is CouldNotCreateNewUserException) {
            await showErrorDialog(context, 'Failed to save username');
          } else if (state.exception is InvalidPasswordAuthException) {
            await showErrorDialog(context, 'Password cannot be empty!');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
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
          title: GradientText(
            'Create Account',
            style: CustomFontStyles.appBarTitle,
            colors: const [AppColors.lighterBlue, AppColors.darkestBlue],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Username',
                  style: CustomFontStyles.textFieldLabel,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyAuthTextField(
                  controller: _username,
                  hintText: "Enter your name",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
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
                  hintText: "Enter your email",
                  textInputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 45),
                MyButton(
                    onPressed: () async {
                      final username = _username.text;
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventRegister(username, email, password),
                          );
                    },
                    text: 'Create Account'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
