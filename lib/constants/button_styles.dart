import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

// class to store custom button style
class CustomButtonStyles {
  static ButtonStyle mainButtonStyle = TextButton.styleFrom(
    backgroundColor: AppColors.lighterBlue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
