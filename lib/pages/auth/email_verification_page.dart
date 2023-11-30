import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/utilities/toast_message.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  const AuthEventShouldRegister(),
                );
          },
        ),
        title: Text(
          'Email Verification',
          style: CustomFontStyles.appBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Welcome to LocaInfo! Please check your inbox for a verification email from us. Click the link inside to confirm your email and activate your account. If you did not received any email press the button below.',
              style: CustomFontStyles.instruction,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 40,
            ),
            MyButton(
                onPressed: () {
                  showToastMessage('Email is sent');
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(), // resend email verification
                      );
                },
                text: 'Resend Email'),
            const SizedBox(
              height: 15,
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
    );
  }
}
