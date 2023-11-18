import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  final iconList = <IconData>[
    Icons.home_outlined,
    Icons.article_outlined,
    Icons.bookmark_outline,
    Icons.person_outline,
  ];

  final iconListSelected = <IconData>[
    Icons.home,
    Icons.article,
    Icons.bookmark,
    Icons.person
  ];

  final iconTextList = ['Home', 'News', 'Saved', 'Profile'];

  var _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final icon = isActive ? iconListSelected[index] : iconList[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                iconTextList[index],
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      },
      activeIndex: _bottomNavIndex,
      height: 60,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 26,
      rightCornerRadius: 26,
      onTap: (index) => setState(() => _bottomNavIndex = index),
    );
  }
}
