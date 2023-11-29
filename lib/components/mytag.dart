import 'package:flutter/material.dart';

class MyTag extends StatelessWidget {
  final List<Widget> children;
  final Color backgroundColor;
  const MyTag({
    super.key,
    required this.children,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
