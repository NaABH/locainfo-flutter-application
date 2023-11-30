import 'package:flutter/material.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// dialog display to user when an error occur
Future<void> showErrorDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: 'An error occurred',
      content: text,
      optionsBuilder: () => {'OK': null});
}
