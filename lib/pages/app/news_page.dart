import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/location/location_exceptions.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String? selectedCategory; // Default category is All

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
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
          if (state.exception is CouldNotGetLocationException) {
            await showErrorDialog(context,
                'An error occurred when getting your current location.');
          } else if (state.exception is CouldNotGetPostsException) {
            await showErrorDialog(
                context, 'An error occurred when fetching post.');
          }
        }
      },
      child: Scaffold(
        appBar: const MyAppBar(
          needBackButton: false,
          title: 'News',
          needNotification: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostStatePostLoaded) {
                final allNearbyPosts = state.posts;
                return Column(
                  children: [
                    _myCategoryButtons(),
                    Expanded(
                      child: MyPostList(
                        posts: allNearbyPosts,
                        postPatternType: PostPatternType.news,
                        selectedCategory: selectedCategory,
                        currentPosition: state.currentPosition,
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
                );
              } else if (state is PostStateNoAvailablePost) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Sorry. There is no post available for your current location'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: IconButton(
                            onPressed: () async {
                              context
                                  .read<PostBloc>()
                                  .add(const PostEventLoadNearbyPosts());
                            },
                            icon: const Icon(Icons.refresh)),
                      ),
                    ],
                  ),
                );
              } else if (state is PostStateLoadError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Try again'),
                      ),
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
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _myCategoryButtons() {
    // All as the default category
    final List<String> categoryKeys = ['All', ...postCategories.keys.toList()];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: categoryKeys.map((categoryKey) {
          final categoryText = postCategories[categoryKey] ?? 'All';
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 4),
            child: ElevatedButton(
              onPressed: () {
                // Update the selected category when a button is pressed
                setState(() {
                  selectedCategory = categoryKey == 'All' ? null : categoryKey;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedCategory == categoryKey ||
                        (selectedCategory == null && categoryKey == 'All')
                    ? AppColors
                        .grey5 // Change the color for the selected category
                    : AppColors.grey2,
              ),
              child: Text(
                categoryText,
                style: const TextStyle(
                  color: AppColors.darkerBlue,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
