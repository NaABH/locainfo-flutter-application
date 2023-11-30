import 'package:flutter/material.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// dialog display to ensure user want to clear all bookmark
Future<bool> showAllClearBookmarkDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirmation',
    content: 'Are you sure you want to clear all bookmarks ?',
    optionsBuilder: () => {'Cancel': false, 'Clear': true},
  ).then((value) => value ?? false);
}
