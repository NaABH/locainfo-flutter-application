import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/icons.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _bottomNavIndex;

  @override
  void initState() {
    final state = context.read<MainBloc>().state;
    _bottomNavIndex = _mapStateToIndex(state);
    super.initState();
  }

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
      activeIndex: _bottomNavIndex,
      height: 55,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 26,
      rightCornerRadius: 26,
      onTap: (index) {
        setState(() => _bottomNavIndex = index);
        context.read<MainBloc>().add(MainEventNavigationChanged(index: index));
      },
    );
  }

  // Helper method to map MainState to the corresponding index
  int _mapStateToIndex(MainState state) {
    if (state is MainStateHome) {
      return 0;
    } else if (state is MainStateNews) {
      return 1;
    } else if (state is MainStateBookmark) {
      return 2;
    } else if (state is MainStateProfile) {
      return 3;
    } else {
      return 0; // Default to home page
    }
  }
}
