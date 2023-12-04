import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

// custom button
class MyButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const MyButton({Key? key, required this.onPressed, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [AppColors.lightestBlue, AppColors.darkerBlue],
            ),
            color: AppColors.lighterBlue,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: AppColors.grey9.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(2, 2),
              )
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: CustomFontStyles.buttonLabel,
            ),
          ),
        ),
      ),
    );
  }
}
