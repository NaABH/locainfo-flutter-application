import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

// custom divider
class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.grey3,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
