import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: 450,
                child: Image.asset('assets/icon/icon_transparent.png'),
              ),
              const SizedBox(height: 10),

              // Logo Name
              FontHeading1(text: 'Welcome to LocaInfo'),

              // Get started
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FontLabel(text: 'Get Started'),
              ),

              // divider
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: MyButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldLogIn(),
                          );
                    },
                    text: 'Log In'),
              ),

              // Signup Button
              MyButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  text: 'Create Account'),
            ],
          ),
        ),
      ),
    );
  }
}
