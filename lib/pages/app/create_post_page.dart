import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/app_colors.dart';
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
  late final ImagePicker _picker;
  String? selectedCategory;
  File? image;

  @override
  void initState() {
    _textControllerTitle = TextEditingController();
    _textControllerBody = TextEditingController();
    _picker = ImagePicker();
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create Post',
                style: CustomFontStyles.appBarTitle,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MyButton(
                    onPressed: () {
                      context.read<PostBloc>().add(PostEventCreatePost(
                            _textControllerTitle.text,
                            _textControllerBody.text,
                            selectedCategory,
                          ));
                      // Navigator.of(context).pop(); // to be debug
                    },
                    text: 'Submit'),
              ),
            ],
          ),
        ),
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
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
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
                          GestureDetector(
                            onTap: () async {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                final imageTemp = File(image.path);
                                setState(() => this.image = imageTemp);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12, left: 12),
                              child: Icon(
                                Icons.image,
                                size: 30,
                                color: AppColors.grey6,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              if (image != null) {
                                final imageTemp = File(image.path);
                                setState(() => this.image = imageTemp);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12, left: 56),
                              child: Icon(
                                Icons.camera_alt,
                                size: 30,
                                color: AppColors.grey6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                image == null
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Stack(children: [
                          Center(
                            child: Image.file(
                              image!,
                              height: 120,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                image = null;
                              });
                            },
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ]),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
