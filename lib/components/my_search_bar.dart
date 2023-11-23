import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  const MySearchBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: false,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.lighterBlue,
            width: 2,
          ),
        ),
        fillColor: Colors.grey.shade200,
        filled: true,
        hintText: "Enter your email",
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
    );
  }
}
