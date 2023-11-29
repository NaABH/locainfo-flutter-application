import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/constants/actions.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String? selectedCategory; // Default category is "All"

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
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
        },
        child: BlocBuilder<PostBloc, PostState>(
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
              return Column(
                children: [
                  _buildCategoryButtons(),
                  Expanded(
                    child: MyPostList(
                      postPatternType: PostPatternType.newsPost,
                      selectedCategory: selectedCategory,
                      posts: allNearbyPosts,
                      bookmarkedPosts: state.bookmarkedPosts,
                      currentPosition: state.currentPosition,
                      onTap: (post) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailPage(
                                post: post, bookmarksId: state.bookmarkedPosts),
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
                    const Text(
                        'Kindly check your GPS and Internet connection.'),
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
      ),
    );
  }

  Widget _buildCategoryButtons() {
    // Add 'All' as the default category
    final List<String> categoryKeys = ['All', ...categories.keys.toList()];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: categoryKeys.map((categoryKey) {
          final categoryText = categories[categoryKey] ?? 'All';
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
