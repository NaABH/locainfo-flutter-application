import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_search_bar.dart';
import 'package:locainfo/pages/app/post_detail_page.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
    context.read<PostBloc>().add(const PostEventSavePreviousState());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBackButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<PostBloc>().add(const PostEventBackToLastState());
          },
        ),
        centerTitle: true,
        title: MySearchBar(
          focusNode: _searchFocusNode,
          controller: _searchController,
          hintText: 'Search posts',
          onChanged: (value) {
            context.read<PostBloc>().add(PostEventSearchPostTextChanged(value));
          },
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        if (state is PostStateSearchLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostStateSearchLoaded) {
          final filteredPosts = state.filteredPosts;
          return ListView(
            children: filteredPosts.isEmpty
                ? [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text('No posts found'),
                      ),
                    ),
                  ]
                : filteredPosts.map((post) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100),
                      child: ListTile(
                        leading: const Icon(Icons.search),
                        title: Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          post.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
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
                    );
                  }).toList(),
          );
        } else if (state is PostStateSearchError) {
          return const Center(child: Text('There is an error when searching'));
        } else {
          return const Center(child: Text('Search post by title...'));
        }
      }),
    );
  }
}
