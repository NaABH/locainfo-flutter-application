import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/components/my_pressableText.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/clear_all_bookmark_dialog.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';

class BookMarkPage extends StatelessWidget {
  const BookMarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) async {
        if (state is PostStateLoadingPosts) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText!,
            );
          } else {
            LoadingScreen().hide();
          }
        } else if (state is PostStateLoadError) {
          if (state.exception is CouldNotGetBookmarkPostException) {
            await showErrorDialog(context,
                'An error occurred when fetching your bookmark posts.');
          }
        } else if (state is PostStateClearBookmarkError) {
          showErrorDialog(context,
              'Some error occurred when clearing all bookmarks. Try again later.');
          context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
        } else if (state is PostStateClearBookmarkSuccessfully) {
          context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
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
            if (state is PostStateLoadedBookmarkedPosts) {
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
                                await showAllClearBookmarkDialog(context);
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
                        postPatternType: PostPatternType.bookmark,
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
                    ),
                  ],
                ),
              );
            } else if (state is PostStateNoAvailableBookmarkPost) {
              return const Center(
                child: Text('You does not bookmark any post.'),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Try again'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
