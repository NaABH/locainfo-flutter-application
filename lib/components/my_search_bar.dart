import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

// custom search bar design
class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FocusNode? focusNode;
  final Function(String) onChanged;
  const MySearchBar(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.onChanged,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.centerRight, children: [
      TextField(
        focusNode: focusNode,
        controller: controller,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        onChanged: onChanged,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.grey3,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: AppColors.grey3,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.grey5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          controller.clear();
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.cancel,
            size: 24,
            color: AppColors.grey5,
          ),
        ),
      )
    ]);
  }
}
