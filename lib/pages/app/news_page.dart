import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            AppBarHeading(text: 'News'),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              icon: const Icon(
                Icons.notifications,
                color: AppColors.main_blue,
                size: 26,
              )),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 1000,
            color: Colors.grey.shade100,
            child: (Text('asdas')),
          )
        ],
      ),
    );
  }
}
