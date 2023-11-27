import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            Text(
              'News',
              style: CustomFontStyles.appBarTitle,
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications,
                color: AppColors.darkerBlue,
                size: 26,
              )),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostStateLoadingPosts) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Fetching news...'),
                ],
              ),
            );
          } else if (state is PostStateLoaded) {
            final allNearbyPosts = state.posts;
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
              },
              child: MyPostList(
                posts: allNearbyPosts,
                onTap: (post) {},
              ),
            );
          } else if (state is PostStateNoAvailablePost) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Sorry. There is no post available for your current location'),
                  IconButton(
                      onPressed: () async {
                        context
                            .read<PostBloc>()
                            .add(const PostEventLoadNearbyPosts());
                      },
                      icon: const Icon(Icons.refresh)),
                ],
              ),
            );
          } else {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Text('Failed to load post at this moment.'),
                  const Text('Kindly check your GPS and Internet connection.'),
                  IconButton(
                      onPressed: () async {
                        context
                            .read<PostBloc>()
                            .add(const PostEventLoadNearbyPosts());
                      },
                      icon: const Icon(Icons.refresh)),
                ]));
          }
        },
      ),
    );
  }
}
