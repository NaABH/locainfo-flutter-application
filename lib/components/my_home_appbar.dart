import 'package:flutter/material.dart';
import 'package:locainfo/constants/app_colors.dart';

class MyHomeAppBar extends StatelessWidget {
  const MyHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.transparent,
          ),
          const Row(
            children: [
              Icon(
                Icons.place,
                size: 22,
                color: AppColors.lighterBlue,
              ),
              Text(
                'LocationName',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lighterBlue,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 4)
              ],
            ),
            child: const Icon(
              Icons.search,
              size: 32,
              color: AppColors.white,
            ),
          )
        ],
      ),
    );
  }
}
