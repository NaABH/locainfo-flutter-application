import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/components/my_snackbar.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/loading_screen/animeated_loading_screen.dart';
import 'package:locainfo/utilities/toast_message.dart';

class PostedPostsPage extends StatefulWidget {
  const PostedPostsPage({super.key});

  @override
  State<PostedPostsPage> createState() => _PostedPostsPageState();
}

class _PostedPostsPageState extends State<PostedPostsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        ScaffoldMessenger.of(context)
            .showSnackBar(mySnackBar(message: 'You have reach the bottom'));
      }
    });
    context.read<PostBloc>().add(const PostEventLoadPostedPosts());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateDeletePostSuccessful) {
          showToastMessage('Post deleted');
          context.read<PostBloc>().add(const PostEventLoadPostedPosts());
        } else if (state is PostStateDeleteError) {
          showToastMessage('Error occurred when deleting post');
          context.read<PostBloc>().add(const PostEventLoadPostedPosts());
        }
      },
      child: Scaffold(
        appBar: MyAppBar(
          leading: MyBackButton(onPressed: () {
            Navigator.of(context).pop();
          }),
          title: 'Posted Posts',
          needNotification: false,
          scrollController: _scrollController,
        ),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostStateLoadingPosts) {
              return AnimatedLoadingScreen(
                  imagePath: 'assets/animated_icon/loading.json',
                  text: 'Fetching nearby news..',
                  imageSize: MediaQuery.of(context).size.width * 0.4);
            }
            if (state is PostStateLoadedPostedPost) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<PostBloc>()
                      .add(const PostEventLoadPostedPosts());
                },
                child: MyPostList(
                  scrollController: _scrollController,
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
              return const Center(
                child: Text('You does not posted any post before.'),
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
