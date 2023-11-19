import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<MainBloc>().add(const MainEventInitialise());
    return BlocConsumer<MainBloc, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is MainStateHome) {
            return const HomePage();
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
        });
  }
}
