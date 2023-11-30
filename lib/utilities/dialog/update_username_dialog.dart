import 'package:flutter/material.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// dialog display to ensure user want to change their username
Future<bool> showChangeUsernameDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Change confirmation',
    content: 'Are you sure you want to change your username?',
    optionsBuilder: () => {'Cancel': false, 'Yes': true},
  ).then((value) => value ?? false); // default value is false
}
