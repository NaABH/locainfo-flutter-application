import 'package:flutter/cupertino.dart';
import 'package:locainfo/utilities/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {'Cancel': false, 'Log out': true},
  ).then((value) => value ?? false); // default value is false
}
