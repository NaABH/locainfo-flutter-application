import 'package:flutter/material.dart';
import 'package:locainfo/utilities/dialog/generic_dialog.dart';

// // dialog display to ensure user want to delete a post
Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Confirmation',
    content: 'Are you sure you want to delete this post?',
    optionsBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
