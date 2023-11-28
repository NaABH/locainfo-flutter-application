import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/post.dart';
import 'package:locainfo/services/post_bloc/post_bloc.dart';
import 'package:locainfo/services/post_bloc/post_event.dart';

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
  File? image;
  late Post currentPost;

  @override
  void initState() {
    currentPost = widget.post;
    image = Image.network(widget.post.imageUrl!) as File?;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
                          currentPost.category,
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
    );
  }
}
