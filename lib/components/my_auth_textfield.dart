import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

// custom text field widget to be used in the authentication process
class MyAuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool hideText;
  final bool wantSuggestion;
  final bool autoCorrect;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final Function(String)? onChanged; // to be used in the search page

  const MyAuthTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.hideText = false,
    this.wantSuggestion = false,
    this.autoCorrect = false,
    this.focusNode,
    this.onChanged,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: hideText,
      enableSuggestions: wantSuggestion,
      autocorrect: autoCorrect,
      keyboardType: textInputType,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.lighterBlue,
            width: 2,
          ),
        ),
        fillColor: AppColors.grey2,
        filled: true,
        hintText: hintText,
        hintStyle: CustomFontStyles.hintText,
      ),
    );
  }
}
