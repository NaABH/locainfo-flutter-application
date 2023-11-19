import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int bottomNavIndex;
  const MyBottomNavigationBar({super.key, required this.bottomNavIndex});

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
              color: AppColors.main_blue,
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                iconTextList[index],
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            )
          ],
        );
      },
      backgroundColor: Colors.grey.shade100,
      borderColor: Colors.grey.shade300,
      activeIndex: widget.bottomNavIndex,
      height: 60,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 26,
      rightCornerRadius: 26,
      onTap: (index) {
        context.read<MainBloc>().add(MainEventNavigationChanged(index: index));
      },
    );
  }
}
