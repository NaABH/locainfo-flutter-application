import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostListPage extends StatefulWidget {
  @override
  _PostListPageState createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('posts');
  String _searchText = '';

  @override
  void initState() {
    _searchFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: const InputDecoration(
            hintText: 'Search posts',
          ),
          onChanged: (value) {
            setState(() {
              _searchText = value.trim().toLowerCase();
            });
          },
        ),
      ),
      body: _searchText.isEmpty
          ? const Center(
              child: Text('No result'),
            ) // Display nothing if the search text is empty
          : StreamBuilder<QuerySnapshot>(
              stream: posts.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final filteredPosts = snapshot.data!.docs.where((doc) {
                  return doc['title']
                      .toString()
                      .toLowerCase()
                      .contains(_searchText);
                }).toList();
                return ListView(
                  children: filteredPosts.map((doc) {
                    return ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['text']),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}
