import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;
  String? selectedCategory;

  @override
  void initState() {
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

  void handleValueChange(String value) {
    setState(() {
      selectedCategory = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<PostBloc>().add(const PostEventCreatePostInitialise());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Create Post',
            style: CustomFontStyles.appBarTitle,
          )),
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
                      maxLines: 6,
                      maxLength: 200,
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
              MyDropdownMenu(onValueChange: handleValueChange),
              const SizedBox(height: 5),
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostStateLoadingCurrentLocation) {
                    return Text(
                      'Current Location: Unknown, Unknown',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    );
                  } else if (state is PostStateWantCreatePost) {
                    final currentLocation = state.position;
                    return Text(
                      'Current Location: ${currentLocation.latitude}, ${currentLocation.longitude}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 20),
              MyButton(
                  onPressed: () {
                    context.read<PostBloc>().add(PostEventCreatePost(
                          _textControllerTitle.text,
                          _textControllerBody.text,
                          selectedCategory!,
                        ));
                    Navigator.of(context).pop(); // to be debug
                  },
                  text: 'Submit'),
            ],
          ),
        ),
      ),
    );
  }
}
