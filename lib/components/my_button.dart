import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

// Custom button
class MyButton extends StatelessWidget {
  final String text;
  const MyButton({super.key, required this.onPressed, required this.text});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
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
        child: Center(
          child: Text(
            text,
            style: CustomFontStyles.buttonLabel,
          ),
        ),
      ),
    );
  }
}
