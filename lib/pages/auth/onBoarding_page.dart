import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_divider.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SizedBox(
                height: MediaQuery.of(context).size.height * 5 / 10,
                child: Image.asset('assets/icon/icon_transparent.png'),
              ),

              // Padding
              const SizedBox(height: 10),

              // Logo Name
              GradientText(
                'Welcome to LocaInfo',
                style: CustomFontStyles.headingOne,
                colors: const [AppColors.lighterBlue, AppColors.darkestBlue],
              ),

              // Get started
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Get Started',
                  style: CustomFontStyles.label,
                ),
              ),

              // divider
              const MyDivider(),

              // Login Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
                child: MyButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldLogIn(),
                          );
                    },
                    text: 'Log In'),
              ),

              // Signup Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: MyButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    text: 'Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
