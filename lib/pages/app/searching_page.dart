import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_search_bar.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MySearchBar(
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
                          post.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {},
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
      // body: _searchText == null
      //     ? const Center(
      //         child: Text('No result'),
      //       ) // Display nothing if the search text is empty
      //     : StreamBuilder<QuerySnapshot>(
      //         stream: posts.snapshots(),
      //         builder: (context, snapshot) {
      //           if (!snapshot.hasData) {
      //             return const Center(child: CircularProgressIndicator());
      //           }
      //           final filteredPosts = snapshot.data!.docs.where((doc) {
      //             return doc['title']
      //                 .toString()
      //                 .toLowerCase()
      //                 .contains(_searchText!);
      //           }).toList();
      //           return ListView(
      //             children: filteredPosts.isEmpty
      //                 ? [
      //                     const Padding(
      //                       padding: EdgeInsets.all(20.0),
      //                       child: Center(
      //                         child: Text('No posts found'),
      //                       ),
      //                     ),
      //                   ]
      //                 : filteredPosts.map((doc) {
      //                     return Container(
      //                       margin: const EdgeInsets.symmetric(
      //                           horizontal: 12, vertical: 1),
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(12),
      //                           color: Colors.grey.shade100),
      //                       child: ListTile(
      //                         leading: const Icon(Icons.search),
      //                         title: Text(
      //                           doc['title'],
      //                           maxLines: 2,
      //                           overflow: TextOverflow.ellipsis,
      //                           softWrap: true,
      //                           style: const TextStyle(
      //                               fontWeight: FontWeight.w500),
      //                         ),
      //                         subtitle: Text(
      //                           doc['text'],
      //                           maxLines: 1,
      //                           overflow: TextOverflow.ellipsis,
      //                         ),
      //                         onTap: () {},
      //                       ),
      //                     );
      //                   }).toList(),
      //           );
      //         },
      //       ),
    );
  }
}
