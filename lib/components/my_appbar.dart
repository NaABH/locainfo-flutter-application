import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool needSearch;
  final VoidCallback? onPressed;
  final ScrollController? scrollController;
  final Widget? leading;
  final Widget? action;
  const MyAppBar({
    super.key,
    required this.title,
    required this.needSearch,
    this.onPressed,
    this.scrollController,
    this.leading,
    this.action,
  });

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
              if (scrollController != null) {
                scrollController!.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              title,
              style: CustomFontStyles.appBarTitle,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          action ?? Container(),
        ],
      ),
      actions: [
        needSearch
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.darkerBlue,
                      size: 30,
                    )),
              )
            : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
