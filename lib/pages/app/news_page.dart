import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_post_list.dart';
import 'package:locainfo/components/my_snackbar.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/constants/custom_datatype.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/location/location_exceptions.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/animeated_loading_screen.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final ScrollController _scrollController;
  String? selectedCategory; // Default category is All
  String selectedSortBy = 'Nearest';

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
    context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
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
      listener: (context, state) async {
        if (state is PostStateLoadError) {
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
        resizeToAvoidBottomInset: false,
        appBar: MyAppBar(
          title: 'News',
          needSearch: true,
          onSearchPressed: () {
            Navigator.of(context).pushNamed(searchPostRoute);
          },
          scrollController: _scrollController,
          afterTitle: _mySortByDropDown(),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
          },
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostStateLoadingPosts) {
                return AnimatedLoadingScreen(
                    imagePath: 'assets/animated_icon/loading.json',
                    text: 'Fetching nearby news..',
                    imageSize: MediaQuery.of(context).size.width * 0.4);
              } else if (state is PostStatePostLoaded) {
                final allNearbyPosts = state.posts;
                return Column(
                  children: [
                    _myCategoryButtons(),
                    Expanded(
                      child: MyPostList(
                        scrollController: _scrollController,
                        posts: allNearbyPosts,
                        postPatternType: PostPatternType.news,
                        selectedCategory: selectedCategory,
                        selectedSortBy: selectedSortBy,
                        currentPosition: state.currentPosition,
                        onTap: (post) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                post: post,
                              ),
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
              } else {
                // PostStateLoadError

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            'Some error occurred. \nPlease check your Internet connection and GPS service.'),
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
              }
            },
          ),
        ),
      ),
    );
  }

  // category butttons
  Widget _myCategoryButtons() {
    // All as the default category
    final List<String?> categoryKeys = [null, ...postCategories.keys.toList()];

    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: SingleChildScrollView(
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
                    selectedCategory = categoryKey;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedCategory == categoryKey
                      ? AppColors.grey5
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
      ),
    );
  }

  // sort by drop down button at the app bar
  Widget _mySortByDropDown() {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: AppColors.grey3,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(12),
          underline: Container(),
          value: selectedSortBy,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 22,
          elevation: 16,
          style: const TextStyle(color: AppColors.black),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedSortBy = newValue;
              });
            }
          },
          items: <String>['Nearest', 'Newest', 'Popular']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
