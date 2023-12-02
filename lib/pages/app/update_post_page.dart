import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/categories.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/cloud_storage/cloud_storage_exceptions.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_exceptions.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';
import 'package:locainfo/utilities/toast_message.dart';

class UpdatePostPage extends StatefulWidget {
  final Post post;

  const UpdatePostPage({super.key, required this.post});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;
  late final ImagePicker _picker;
  late final Post currentPost;
  File? newImage;
  File? oldImage;
  bool imageUpdated = false;

  @override
  void initState() {
    currentPost = widget.post;
    _textControllerTitle = TextEditingController(text: currentPost.title);
    _textControllerBody = TextEditingController(text: currentPost.content);
    _picker = ImagePicker();
    if (currentPost.imageUrl != null) {
      oldImage = File(currentPost.imageUrl!);
    }
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
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) async {
        if (state is PostStateUpdatingPosts) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText!,
            );
          } else {
            LoadingScreen().hide();
          }
        } else if (state is PostStateUpdatePostSuccessfully) {
          Navigator.of(context).pop();
          showToastMessage('Post is updated');
          context.read<PostBloc>().add(const PostEventLoadPostedPosts());
        } else if (state is PostStateUpdatePostError) {
          if (state.exception is TitleCouldNotEmptyPostException) {
            await showErrorDialog(
                context, 'Title cannot be empty or start with symbol.');
          } else if (state.exception is ContentCouldNotEmptyPostException) {
            await showErrorDialog(
                context, 'Content cannot be empty or start with symbol.');
          } else if (state.exception is CouldNotUploadPostImageException) {
            await showErrorDialog(
                context, 'An error occurred when updating the new image.');
          } else if (state.exception is CouldNotUpdatePostException) {
            await showErrorDialog(
                context, 'An error occurred when saving the updated post.');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Post',
                style: CustomFontStyles.appBarTitle,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: MyButton(
                    onPressed: () {
                      context.read<PostBloc>().add(PostEventUpdatePostContent(
                            currentPost.documentId,
                            _textControllerTitle.text,
                            _textControllerBody.text,
                            newImage,
                            imageUpdated,
                          ));
                      // Navigator.of(context).pop(); // to be debug
                    },
                    text: 'Update'),
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
                                setState(() {
                                  newImage = imageTemp;
                                  imageUpdated = true;
                                });
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
                                setState(() {
                                  newImage = imageTemp;
                                  imageUpdated = true;
                                });
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
                oldImage == null && newImage == null
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
                            child: newImage != null
                                ? Image.file(
                                    newImage!,
                                    height: 120,
                                  )
                                : Image.network(
                                    oldImage!.path,
                                    height: 120,
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                oldImage = null;
                                newImage = null;
                                imageUpdated = true;
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
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.grey4,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          postCategories[currentPost.category]!,
                          style: TextStyle(
                              color: AppColors.grey7,
                              fontWeight: FontWeight.w400),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.grey5,
                        ),
                      ],
                    )),
                const SizedBox(height: 5),
                Text(
                  'Current Location: ${currentPost.latitude}, ${currentPost.longitude}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade500,
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
