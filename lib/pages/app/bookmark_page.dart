import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/components/my_pressableText.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';
import 'package:locainfo/utilities/clear_all_bookmark_dialog.dart';
import 'package:locainfo/utilities/error_dialog.dart';

class BookMarkPage extends StatelessWidget {
  const BookMarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateClearBookmarkSuccessfully) {
          context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
        } else if (state is PostStateClearBookmarkError) {
          showErrorDialog(context,
              'Some error occur when clearing all bookmarks. Try again later.');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: Row(
            children: [
              Text(
                'Bookmark',
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
                    Text('Fetching bookmarks...'),
                  ],
                ),
              );
            } else if (state is PostStateLoadedBookmarkedPosts) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<PostBloc>()
                      .add(const PostEventLoadBookmarkedPosts());
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 8),
                      child: MyPressableText(
                          text: 'Clear all',
                          onPressed: () async {
                            final wantClear =
                                await showClearAllBookmarkDialog(context);
                            if (wantClear) {
                              context
                                  .read<PostBloc>()
                                  .add(const PostEventClearAllBookmark());
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: MyPostList(
                        posts: state.posts,
                        bookmarkedPosts: state.bookmarkedPosts,
                        onTap: (post) {},
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is PostStateNoAvailableBookmarkPost) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('You does not bookmark any post.'),
                    IconButton(
                        onPressed: () async {
                          context
                              .read<PostBloc>()
                              .add(const PostEventLoadBookmarkedPosts());
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
                    const Text(
                        'Kindly check your GPS and Internet connection.'),
                    IconButton(
                        onPressed: () async {
                          context
                              .read<PostBloc>()
                              .add(const PostEventLoadBookmarkedPosts());
                        },
                        icon: const Icon(Icons.refresh)),
                  ]));
            }
          },
        ),
      ),
    );
  }
}
