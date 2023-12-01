import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool needBackButton;
  final String title;
  final bool needNotification;
  const MyAppBar({
    super.key,
    required this.needBackButton,
    required this.title,
    required this.needNotification,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.white,
      title: needBackButton
          ? Row(
              children: [
                Text(
                  title,
                  style: CustomFontStyles.appBarTitle,
                ),
              ],
            )
          : Container(),
      actions: [
        needNotification
            ? IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  color: AppColors.darkerBlue,
                  size: 26,
                ))
            : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
