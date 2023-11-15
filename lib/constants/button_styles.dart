import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class CustomButtonStyles {
  static ButtonStyle main_button_style = TextButton.styleFrom(
    backgroundColor: AppColors.secondary_blue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
