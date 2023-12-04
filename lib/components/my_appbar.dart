import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

// custom app bar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool needSearch;
  final VoidCallback?
      onSearchPressed; // call back when search button is clicked
  final ScrollController? scrollController;
  final Widget? leading;
  final Widget? action;
  final Widget? afterTitle;

  const MyAppBar({
    Key? key,
    required this.title,
    required this.needSearch,
    this.onSearchPressed,
    this.scrollController,
    this.leading,
    this.action,
    this.afterTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      elevation: 0,
      backgroundColor: AppColors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              scrollController?.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: GradientText(
              title,
              style: CustomFontStyles.appBarTitle,
              colors: const [AppColors.lighterBlue, AppColors.darkestBlue],
            ),
          ),
          const SizedBox(width: 20),
          afterTitle ?? Container(),
        ],
      ),
      actions: [
        if (needSearch)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: onSearchPressed,
              icon: const Icon(
                Icons.search,
                color: AppColors.darkerBlue,
                size: 30,
              ),
            ),
          ),
        if (action != null) action!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
