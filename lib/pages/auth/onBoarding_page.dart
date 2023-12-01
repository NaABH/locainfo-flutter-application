import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_divider.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/auth_exceptions.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/bloc/auth_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggingInWithGoogle) {
          if (state.exception is CouldNotSignInWithGoogleException) {
            await showErrorDialog(
                context, 'Some error occurred when signing in with Google.');
          }
        }
      },
      child: Scaffold(
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
                  height: MediaQuery.of(context).size.height * 0.45,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25),
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
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 15),
                  child: _signInWithGoogleButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInWithGoogleButton() {
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(const AuthEventSignInWithGoogle());
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [AppColors.grey50, AppColors.grey4],
          ),
          color: AppColors.lighterBlue,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/image/google.png'),
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Continue with Google',
                style: TextStyle(
                  color: AppColors.darkerBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
