import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_bottom_navigation_bar.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/pages/app/bookmark_page.dart';
import 'package:locainfo/pages/app/news_page.dart';
import 'package:locainfo/pages/app/profile_page.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

import 'app/home_page.dart';

class MainAppPage extends StatelessWidget {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainBloc>().add(const MainEventNavigationChanged(index: 0));
    return Scaffold(
      body: BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          int currentActiveIndex;
          if (state is MainStateHome) {
            currentActiveIndex = 0;
            return const HomePage();
          } else if (state is MainStateNews) {
            currentActiveIndex = 1;
            return const NewsPage();
          } else if (state is MainStateBookmark) {
            currentActiveIndex = 2;
            return const BookMarkPage();
          } else if (state is MainStateProfile) {
            currentActiveIndex = 3;
            return const ProfilePage();
          } else {
            currentActiveIndex = 0;
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Create',
          backgroundColor: AppColors.main_blue,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
