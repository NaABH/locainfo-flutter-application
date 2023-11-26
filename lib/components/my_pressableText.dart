import 'package:flutter/material.dart';
import 'package:locainfo/constants/font_styles.dart';

// custom text with onTap function
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
        text,
        style: CustomFontStyles.pressableText,
      ),
    );
  }
}
