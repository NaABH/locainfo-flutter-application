import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class MyProfileListTile extends StatelessWidget {
  final Function() onTap;
  final IconData leadingIcon;
  final IconData trailingIcon;
  final String title;
  const MyProfileListTile(
      {super.key,
      required this.onTap,
      required this.leadingIcon,
      required this.trailingIcon,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.grey3.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              onTap: onTap,
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [AppColors.grey1, AppColors.grey5],
                    ),
                    borderRadius: BorderRadius.circular(36)),
                child: Icon(
                  leadingIcon,
                  size: 36,
                ),
              ),
              title: Text(
                title,
                style:
                    const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
              trailing: Container(
                margin: const EdgeInsets.only(right: 18),
                child: Icon(
                  trailingIcon,
                  size: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
