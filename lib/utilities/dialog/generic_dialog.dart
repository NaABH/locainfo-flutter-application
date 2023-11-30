import 'package:flutter/material.dart';
import 'package:locainfo/constants/font_styles.dart';

// idea come from https://youtu.be/VPvVD8t02U8?si=Qd-d_xGvdbAWYUIw
// A generic class to build a dialog
typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder
      optionsBuilder, // a function to build the options that will be displayed in the dialog
}) {
  final options = optionsBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: CustomFontStyles.dialogHeading,
          ),
          content: Text(
            content,
            style: CustomFontStyles.defaultFont,
          ),
          actions: options.keys.map((optionTitle) {
            final T value = options[optionTitle];
            return TextButton(
                onPressed: () {
                  if (value != null) {
                    Navigator.of(context)
                        .pop(value); // close the dialog and return the value
                  } else {
                    Navigator.of(context).pop(); // close the dialog
                  }
                },
                child: Text(optionTitle));
          }).toList(),
        );
      });
}
