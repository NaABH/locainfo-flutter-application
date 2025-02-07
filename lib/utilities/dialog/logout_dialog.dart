import 'package:flutter/cupertino.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// dialog display to ensure user want to log out
Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {'Cancel': false, 'Log out': true},
  ).then((value) => value ?? false); // default value is false
}
