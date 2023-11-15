import 'package:flutter/material.dart';

class MyPressableText extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const MyPressableText(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: Colors.grey.shade600,
          // decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
