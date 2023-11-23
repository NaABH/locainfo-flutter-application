import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class CustomFontStyles {
  // used for appbar title
  static const TextStyle appBarTitle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.darkerBlue,
    fontSize: 24.0,
  );

  // used for onBoarding page (Get Started)
  static const TextStyle label = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 18,
    color: Colors.black,
  );

  // used for general dialog
  static const TextStyle defaultFont = TextStyle(
    fontWeight: FontWeight.w400,
  );

  // used for general dialog
  static const TextStyle dialogHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  // used for
  static const TextStyle headingOne = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // used for
  static const TextStyle headingTwo = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );

  // used for forgot password
  static const TextStyle instruction = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonLabel = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  static const TextStyle textFieldLabel = TextStyle(
    color: AppColors.darkerBlue,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  // used for hintText
  static TextStyle hintText = TextStyle(
    color: AppColors.grey5,
  );

  // used for pressableText
  static TextStyle pressableText = TextStyle(
      color: AppColors.grey6,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline);
}
