import 'package:flutter/material.dart';
import 'package:locainfo/utilities/generic_dialog.dart';

Future<bool> showClearAllBookmarkDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirmation',
    content: 'Are you sure you want to clear all bookmarks ?',
    optionsBuilder: () => {'Cancel': false, 'Clear': true},
  ).then((value) => value ?? false); // default value is false
}
