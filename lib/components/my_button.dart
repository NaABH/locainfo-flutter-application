import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

class MyButton extends StatelessWidget {
  final String text;
  const MyButton({super.key, required this.onPressed, required this.text});

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: const EdgeInsets.symmetric(horizontal: 25),
    //   height: 48,
    //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
    //   child: TextButton(
    //       style: CustomButtonStyles.main_button_style,
    //       onPressed: onPressed,
    //       child: Center(
    //         child: ButtonLabel(
    //           text: text,
    //         ),
    //       )),
    // );
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: AppColors.secondary_blue,
          borderRadius: BorderRadius.circular(50),
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
            child: ButtonLabel(
          text: text,
        )),
      ),
    );
  }
}
