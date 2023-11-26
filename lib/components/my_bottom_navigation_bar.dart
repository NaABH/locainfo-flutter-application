import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/constants/icons.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

// custom bottom navigation bar
class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int _bottomNavIndex;

  @override
  void initState() {
    super.initState();
    _bottomNavIndex = _mapStateToIndex(context
        .read<MainBloc>()
        .state); // map the selected index to the current state
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final icon = isActive ? iconListSelected[index] : iconList[index];
        return _buildTabItem(icon, iconTextList[index]);
      },
      backgroundColor: AppColors.grey1,
      borderColor: AppColors.grey3,
      activeIndex: _bottomNavIndex,
      height: MediaQuery.of(context).size.height * 1 / 15,
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

  Widget _buildTabItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 30,
          color: AppColors.darkerBlue,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            label,
            style: CustomFontStyles.bottomNavigationBarLabel,
          ),
        )
      ],
    );
  }

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
