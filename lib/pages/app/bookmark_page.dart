import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/components/my_pressableText.dart';
import 'package:locainfo/components/my_snackbar.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/clear_all_bookmark_dialog.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/animeated_loading_screen.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollEnd);
    context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
    super.initState();
  }

  void _onScrollEnd() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ScaffoldMessenger.of(context)
          .showSnackBar(mySnackBar(message: 'You have reached the bottom'));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) => _handleBlocState(context, state),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(
          needSearch: false,
          title: 'Bookmark',
          scrollController: _scrollController,
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostStateLoadingPosts) {
              return AnimatedLoadingScreen(
                imagePath: 'assets/animated_icon/loading_bookmark.json',
                text: 'Fetching bookmarks..',
                imageSize: MediaQuery.of(context).size.width * 0.3,
              );
            } else if (state is PostStateLoadedBookmarkedPosts) {
              return _buildLoadedBookmarkedPosts(state);
            } else if (state is PostStateNoAvailableBookmarkPost) {
              return const Center(
                child: Text('You have not bookmarked any posts.'),
              );
            } else {
              return _buildErrorState(context);
            }
          },
        ),
      ),
    );
  }

  // display bookmarked posts
  Widget _buildLoadedBookmarkedPosts(PostStateLoadedBookmarkedPosts state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
      },
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 8),
            child: MyPressableText(
              text: 'Clear all',
              onPressed: () => _clearAllBookmarks(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: MyPostList(
              scrollController: _scrollController,
              postPatternType: PostPatternType.bookmark,
              posts: state.posts,
              onTap: (post) => _navigateToPostDetail(post),
            ),
          ),
        ],
      ),
    );
  }

  // display error message
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('An error occurred. Please try again.'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: IconButton(
              onPressed: () async {
                context
                    .read<PostBloc>()
                    .add(const PostEventLoadBookmarkedPosts());
              },
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      ),
    );
  }

  // handle the bloc state
  void _handleBlocState(BuildContext context, PostState state) async {
    if (state is PostStateLoadError) {
      if (state.exception is CouldNotGetBookmarkPostException) {
        await showErrorDialog(
            context, 'An error occurred when fetching your bookmarked posts.');
      }
    } else if (state is PostStateClearBookmarkError) {
      showErrorDialog(context,
          'An error occurred when clearing all bookmarks. Try again later.');
      context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
    } else if (state is PostStateClearBookmarkSuccessfully) {
      context.read<PostBloc>().add(const PostEventLoadBookmarkedPosts());
    }
  }

  // clear all bookmarks
  Future<void> _clearAllBookmarks(BuildContext context) async {
    final wantClear = await showAllClearBookmarkDialog(context);
    if (wantClear) {
      context.read<PostBloc>().add(const PostEventClearAllBookmark());
    }
  }

  // when user press on post navigate them to the post detail
  void _navigateToPostDetail(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post),
      ),
    );
  }
}
