import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/cloud_storage/cloud_storage_exceptions.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/location/location_exceptions.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_exceptions.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';
import 'package:locainfo/utilities/toast_message.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;
  late final ImagePicker _picker;
  Position? currentPosition;
  String? selectedCategory;
  File? image;

  @override
  void initState() {
    _textControllerTitle = TextEditingController();
    _textControllerBody = TextEditingController();
    _picker = ImagePicker();
    context.read<PostBloc>().add(const PostEventSavePreviousState());
    context.read<MainBloc>().add(const MainEventSavePreviousState());
    context.read<PostBloc>().add(const PostEventInitialiseCreatePost());
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
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) async {
        if (state is PostStateSubmittingPost) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText!,
            );
          } else {
            LoadingScreen().hide();
          }
        }

        if (state is PostStateCreatingPost) {
          setState(() {
            currentPosition = state.position;
          });
          if (state.exception is TitleCouldNotEmptyPostException) {
            await showErrorDialog(
                context, 'Title could not be empty or start with symbol!');
          } else if (state.exception is ContentCouldNotEmptyPostException) {
            await showErrorDialog(
                context, 'Content could not be empty or start with symbol!');
          } else if (state.exception is InvalidCategoryPostException) {
            await showErrorDialog(context, 'Please select a category!');
          } else if (state.exception is CouldNotGetLocationException) {
            await showErrorDialog(context, 'Your location cannot be accessed!');
          } else if (state.exception is CouldNotCreatePostException) {
            await showErrorDialog(context, 'Unknown error has occurred!');
          } else if (state.exception is CouldNotUploadPostImageException) {
            await showErrorDialog(
                context, 'Error occurred when saving the attached image!');
          }
        } else if (state is PostStateCreatePostSuccessful) {
          showToastMessage('Your post is created successfully');
          context
              .read<MainBloc>()
              .add(const MainEventNavigationChanged(index: 1));
          context.read<PostBloc>().add(const PostEventLoadNearbyPosts());
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<MainBloc>().add(const MainEventBackToLastState());
              context.read<PostBloc>().add(const PostEventBackToLastState());
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
                            image,
                            selectedCategory,
                          ));
                    },
                    text: 'Post'),
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
                          fillColor: AppColors.grey2,
                          filled: true,
                          hintText: "Title",
                          hintStyle: TextStyle(color: AppColors.grey7),
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
                              fillColor: AppColors.grey2,
                              filled: true,
                              hintText: "Description / body text",
                              hintStyle: TextStyle(color: AppColors.grey5),
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
                            color: AppColors.grey2,
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
                                color: AppColors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ]),
                      ),
                MyDropdownMenu(onValueChange: handleValueChange),
                const SizedBox(height: 5),
                Text(
                  (currentPosition == null)
                      ? 'Current Location: Unknown, Unknown'
                      : 'Current Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.grey5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
