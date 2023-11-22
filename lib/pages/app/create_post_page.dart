import 'package:flutter/material.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/firestore/post.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  Post? _post;
  late final FireStoreProvider _databaseProvider;
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;

  @override
  void initState() {
    _databaseProvider = FireStoreProvider();
    _textControllerTitle = TextEditingController();
    _textControllerBody = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textControllerTitle.dispose();
    _textControllerBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: AppBarHeading(text: 'Create Post')),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    TextField(
                      controller: _textControllerTitle,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: true,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Title",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    TextField(
                      controller: _textControllerBody,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: true,
                      maxLines: 4,
                      maxLength: 150,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Description / body text",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const MyDropdownMenu(),
              const SizedBox(height: 20),
              TextField(
                obscureText: false,
                enableSuggestions: true,
                autocorrect: true,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Source",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Current Location: latitude, longitude',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                  onPressed: () async {
                    _databaseProvider.createNewPost(
                        ownerUserId: FirebaseAuthProvider().currentUser!.id,
                        title: _textControllerTitle.text,
                        body: _textControllerBody.text);
                    Navigator.of(context).pop();
                  },
                  text: 'Submit'),
            ],
          ),
        ),
      ),
    );
  }
}
