import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

// custom back button
class MyBackButton extends StatelessWidget {
  final Function()? onPressed;

  const MyBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_outlined,
        color: AppColors.darkerBlue,
      ),
      onPressed: onPressed,
    );
  }
}
