import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class CustomTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.main_blue,
    fontSize: 24.0,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.font_black,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle paragraph = TextStyle(
    fontSize: 16.0,
  );

  static const TextStyle label = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    color: Colors.black,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle textFieldLabel = TextStyle(
    color: AppColors.main_blue,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}

class AppBarHeading extends StatelessWidget {
  final String text;

  AppBarHeading({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.appBarTitle,
    );
  }
}

class FontHeading1 extends StatelessWidget {
  final String text;

  FontHeading1({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.heading1,
    );
  }
}

class FontHeading2 extends StatelessWidget {
  final String text;

  FontHeading2({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.heading2,
    );
  }
}

class FontParagraph extends StatelessWidget {
  final String text;

  FontParagraph({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.paragraph,
    );
  }
}

class FontLabel extends StatelessWidget {
  final String text;

  FontLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.label,
    );
  }
}

class ButtonLabel extends StatelessWidget {
  final String text;

  ButtonLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.buttonLabel,
    );
  }
}

class TextFieldLabel extends StatelessWidget {
  final String text;

  TextFieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: CustomTextStyles.textFieldLabel,
    );
  }
}
