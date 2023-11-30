import 'package:flutter/material.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// dialog display to ensure user want to change profile picture
Future<bool> showChangeProfilePictureDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Change Confirmation',
    content: 'Are you sure you want to change your profile picture?',
    optionsBuilder: () => {'Cancel': false, 'Yes': true},
  ).then((value) => value ?? false); // default value is false
}
