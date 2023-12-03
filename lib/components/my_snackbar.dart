import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

SnackBar mySnackBar({
  required String message,
  Color backgroundColor = AppColors.lighterBlue,
  Duration duration = const Duration(milliseconds: 1100),
  double borderRadius = 10.0,
}) {
  return SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: duration,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(borderRadius),
        topLeft: Radius.circular(borderRadius),
      ),
    ),
  );
}

void showMySnackBar(BuildContext context, String message) {
  final snackBar = mySnackBar(message: message);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
