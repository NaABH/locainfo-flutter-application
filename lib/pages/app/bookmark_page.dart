import 'package:flutter/material.dart';
import 'package:locainfo/components/my_bottom_navigation_bar.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavigationBar(
        bottomNavIndex: 2,
      ),
    );
  }
}
