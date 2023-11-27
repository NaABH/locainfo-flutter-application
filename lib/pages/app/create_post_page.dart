import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/location/location_exceptions.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';
import 'package:locainfo/services/post_bloc/post_exceptions.dart';
import 'package:locainfo/services/post_bloc/post_state.dart';
import 'package:locainfo/utilities/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen.dart';

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
    context.read<PostBloc>().add(const PostEventCreatingPost());
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) async {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Submitting...',
          );
        } else {
          LoadingScreen().hide();
        }

        if (state is PostStateCreatingPost) {
          if (state.exception is TitleCouldNotEmptyPostException) {
            await showErrorDialog(context, 'Title could not be empty!');
          } else if (state.exception is ContentCouldNotEmptyPostException) {
            await showErrorDialog(context, 'Content could not be empty!');
          } else if (state.exception is CategoryInvalidPostException) {
            await showErrorDialog(context, 'Please select a category!');
          } else if (state.exception is CouldNotGetLocationException) {
            await showErrorDialog(context, 'Your location cannot be accessed!');
          } else if (state.exception is CouldNotCreatePostException) {
            await showErrorDialog(context, 'Unknown error has occurred!');
          }
        } else if (state is PostStateCreatePostSuccessful) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            leading: MyBackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
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
                        maxLength: 50,
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
                        maxLength: 250,
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
                BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                  if (state is PostStateCreatingPost) {
                    final position = state.position;
                    return Text(
                      (position == null)
                          ? 'Current Location: Unknown, Unknown'
                          : 'Current Location: ${position.latitude}, ${position.longitude}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
                const SizedBox(height: 20),
                MyButton(
                    onPressed: () {
                      context.read<PostBloc>().add(PostEventCreatePost(
                            _textControllerTitle.text,
                            _textControllerBody.text,
                            selectedCategory,
                          ));
                      // Navigator.of(context).pop(); // to be debug
                    },
                    text: 'Submit'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
