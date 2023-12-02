import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_auth_textfield.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_divider.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/cloud_storage/cloud_storage_exceptions.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/firestore/database_exceptions.dart';
import 'package:locainfo/services/profile/profile_bloc.dart';
import 'package:locainfo/services/profile/profile_event.dart';
import 'package:locainfo/services/profile/profile_exceptions.dart';
import 'package:locainfo/services/profile/profile_state.dart';
import 'package:locainfo/utilities/dialog/change_profile_picture_dialog.dart';
import 'package:locainfo/utilities/dialog/error_dialog.dart';
import 'package:locainfo/utilities/dialog/update_username_dialog.dart';
import 'package:locainfo/utilities/loading_screen/loading_screen.dart';
import 'package:locainfo/utilities/toast_message.dart';

class UpdateProfilePage extends StatefulWidget {
  final CurrentUser user;
  const UpdateProfilePage({super.key, required this.user});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final FocusNode _textFieldFocusNode = FocusNode();
  late CurrentUser _user;
  late String? _profilePicLink;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _user = widget.user;
    _profilePicLink = _user.profilePicLink;
    _usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileStateUpdatingUsername ||
            state is ProfileStateUpdatingPicture) {
          if (state.isLoading) {
            LoadingScreen().show(
              context: context,
              text: state.loadingText!,
            );
          } else {
            LoadingScreen().hide();
          }
        }
        if (state is ProfileStateUpdateUsernameSuccessfully) {
          showToastMessage('Username updated.');
        } else if (state is ProfileStateUpdatePictureSuccessfully) {
          setState(() {
            _profilePicLink = state.imageUrl;
          });
          showToastMessage('Profile picture updated');
        } else if (state is ProfileStateUpdateUsernameError) {
          if (state.exception is UsernameCouldNotBeEmptyProfileException) {
            await showErrorDialog(context,
                'Username cannot be empty or start with special character.');
          } else if (state.exception is CouldNotUpdateUsernameException) {
            await showErrorDialog(context,
                'An error occurred when updating your username on cloud.');
          }
        } else if (state is ProfileStateUpdatePictureError) {
          if (state.exception is CouldNotUploadProfileImageException) {
            await showErrorDialog(
                context, 'An error occurred when saving your image on cloud.');
          } else if (state.exception is CouldNotUpdateProfilePictureException) {
            await showErrorDialog(context,
                'An error occurred when updating your profile picture.');
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
              context
                  .read<ProfileBloc>()
                  .add(const ProfileEventInitialiseProfile());
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Profile',
                style: CustomFontStyles.appBarTitle,
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: Stack(children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: MediaQuery.of(context).size.width / 1.5,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: _profilePicLink != null
                            ? Image.network(
                                _profilePicLink!,
                                fit: BoxFit.fitHeight,
                              )
                            : Image.asset(
                                'assets/image/default-profile.png',
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    ),
                    const Positioned(
                      bottom: 0,
                      right: 40,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 70,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 25),
                const MyDivider(),
                const SizedBox(height: 25),
                MyAuthTextField(
                  focusNode: _textFieldFocusNode,
                  controller: _usernameController,
                  hintText: 'New Username',
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 25),
                MyButton(
                    onPressed: () async {
                      _textFieldFocusNode.unfocus();
                      final shouldChange =
                          await showChangeUsernameDialog(context);
                      if (shouldChange) {
                        context.read<ProfileBloc>().add(
                            ProfileEventUpdateUsername(
                                _usernameController.text));
                      }
                    },
                    text: 'Change Username')
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      final shouldUpdate = await showChangeProfilePictureDialog(context);
      if (shouldUpdate) {
        final imageTemp = File(image.path);
        context
            .read<ProfileBloc>()
            .add(ProfileEventUpdateProfilePicture(imageTemp));
      }
    }
  }
}
