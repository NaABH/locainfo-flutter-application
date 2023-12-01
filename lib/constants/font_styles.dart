import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class CustomFontStyles {
  // used for appbar title
  static TextStyle appBarTitle = const TextStyle(
    fontWeight: FontWeight.w600,
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
    color: AppColors.black,
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
    decoration: TextDecoration.underline,
  );

  // used for label for bottomNavigationBar
  static TextStyle bottomNavigationBarLabel = const TextStyle(
    color: AppColors.black,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // used for selected item in drop down menu
  static TextStyle selectedDropDownItem = TextStyle(
    color: AppColors.grey7,
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
  );

  // used for label for like and dislike count
  static TextStyle likeDislikeButtonLabel = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  // used for text in loading screen
  static TextStyle loadingScreenText = const TextStyle(
    color: AppColors.darkerBlue,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  // used for username row in post
  static TextStyle postUsernameLabel = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  // used for location and date label in post
  static TextStyle postLocationDateLabel = const TextStyle(
    fontSize: 13,
    fontStyle: FontStyle.italic,
    color: AppColors.lightestBlue,
  );

  // used for post title
  static TextStyle postTitleLabel = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );

  static TextStyle postContentText = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );
}
