import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';
import 'package:locainfo/utilities/toast_message.dart';

class PostedPostsPage extends StatelessWidget {
  const PostedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventLoadPostedPosts());
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateLoadingPosts) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText!,
            );
          } else {
            LoadingScreen().hide();
          }
        } else if (state is PostStateDeletePostSuccessful) {
          showToastMessage('Post deleted');
        } else if (state is PostStateDeleteError) {
          showToastMessage('Error occurred when deleting post');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: Row(
            children: [
              Text(
                'Posted Posts',
                style: CustomFontStyles.appBarTitle,
              ),
            ],
          ),
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostStateLoadedPostedPost) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<PostBloc>()
                      .add(const PostEventLoadPostedPosts());
                },
                child: MyPostList(
                  postPatternType: PostPatternType.userPosted,
                  posts: state.posts,
                  onTap: (post) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                ),
              );
            } else if (state is PostStateNoAvailablePostedPost) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You does not posted any post before.'),
                    IconButton(
                        onPressed: () async {
                          context
                              .read<PostBloc>()
                              .add(const PostEventLoadPostedPosts());
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
                    const Text('Try again'),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                          onPressed: () async {
                            context
                                .read<PostBloc>()
                                .add(const PostEventLoadBookmarkedPosts());
                          },
                          icon: const Icon(Icons.refresh)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
