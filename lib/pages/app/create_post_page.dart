import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/app_colors.dart';
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

// a page to enable user to create post
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;
  late final TextEditingController _textControllerContact;
  late final ImagePicker _picker; // from image picker package
  Position? currentPosition;
  String? selectedCategory;
  File? image;

  @override
  void initState() {
    _textControllerTitle = TextEditingController();
    _textControllerBody = TextEditingController();
    _textControllerContact = TextEditingController();
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
    _textControllerContact.dispose();
    super.dispose();
  }

  // change of category value
  void handleValueChange(String value) {
    setState(() {
      selectedCategory = value;
    });
  }

  // let user select image
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  // when user remove the image by click the cancel button
  void _onImageCancel() {
    setState(() {
      image = null;
    });
  }

  // create a create post event
  Future<void> _createPost() async {
    context.read<PostBloc>().add(PostEventCreatePost(
          _textControllerTitle.text,
          _textControllerBody.text,
          image,
          selectedCategory,
          _textControllerContact.text.isNotEmpty
              ? _textControllerContact.text
              : null,
        ));
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
          } else if (state.exception is InvalidContactPostException) {
            await showErrorDialog(context, 'Invalid contact number!');
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
        appBar: MyAppBar(
          needSearch: false,
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<MainBloc>().add(const MainEventBackToLastState());
              context.read<PostBloc>().add(const PostEventBackToLastState());
            },
          ),
          title: 'Create Post',
          action: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: MyButton(
              onPressed: _createPost,
              text: 'Post',
            ),
          ),
        ),
        body: Container(
          color: AppColors.white,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey2,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                            onTap: () async => _pickImage(ImageSource.gallery),
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
                            onTap: () async => _pickImage(ImageSource.camera),
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
                if (image != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.grey2,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.file(
                            image!,
                            height: 120,
                          ),
                        ),
                        GestureDetector(
                          onTap: _onImageCancel,
                          child: const Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.cancel,
                              color: AppColors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                MyDropdownMenu(onValueChange: handleValueChange),
                const SizedBox(height: 10),
                TextField(
                  controller: _textControllerContact,
                  obscureText: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: AppColors.grey2,
                    filled: true,
                    hintText: "Contact (Optional) e.g. 0123456789",
                    hintStyle: TextStyle(color: AppColors.grey5),
                  ),
                ),
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
