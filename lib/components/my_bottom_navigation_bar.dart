import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      shape: const CircularNotchedRectangle(),
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            tooltip: 'Home',
            icon: const Icon(
              Icons.home_outlined,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'News',
            icon: const Icon(
              Icons.article_outlined,
              size: 26,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 60),
          IconButton(
            tooltip: 'Bookmark',
            icon: const Icon(
              Icons.bookmarks_outlined,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Favorite',
            icon: const Icon(
              Icons.person_outline,
              size: 26,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
