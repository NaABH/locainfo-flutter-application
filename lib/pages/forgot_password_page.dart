import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventShouldLogIn(),
                  );
            },
          ),
          title: AppBarHeading(
            text: 'Forgot Password',
          )),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldLabel(text: 'Email Address'),
              const SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: false,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.secondary_blue,
                      width: 2,
                    ),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 25),
              MyButton(onPressed: () {}, text: 'Send Reset Link'),
            ],
          ),
        ),
      ),
    );
  }
}
