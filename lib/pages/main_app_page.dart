import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_bottom_navigation_bar.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/app/bookmark_page.dart';
import 'package:locainfo/pages/app/news_page.dart';
import 'package:locainfo/pages/app/profile_page.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

class MainAppPage extends StatelessWidget {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MainBloc>().add(const MainEventNavigationChanged(index: 0));
    return Scaffold(
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state is MainStateHome) {
            return const NewsPage();
          } else if (state is MainStateNews) {
            return const NewsPage();
          } else if (state is MainStateBookmark) {
            return const BookMarkPage();
          } else if (state is MainStateProfile) {
            return const ProfilePage();
          } else {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
        },
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createPostRoute);
          },
          tooltip: 'Create Post',
          backgroundColor: AppColors.darkerBlue,
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
