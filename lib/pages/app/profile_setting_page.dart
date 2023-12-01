import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locainfo/components/my_auth_textfield.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_divider.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/utilities/dialog/change_profile_picture_dialog.dart';
import 'package:locainfo/utilities/dialog/update_username_dialog.dart';

class UpdateProfilePage extends StatefulWidget {
  final CurrentUser user;
  const UpdateProfilePage({super.key, required this.user});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late CurrentUser _user;
  late final TextEditingController _usernameController;

  @override
  void initState() {
    _user = widget.user;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: MyBackButton(
          onPressed: () {
            context
                .read<MainBloc>()
                .add(const MainEventNavigationChanged(index: 3));
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
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 2.5,
                  backgroundImage: const NetworkImage(
                      'https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-980x653.jpg'),
                  child: const Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 40,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const MyDivider(),
              const SizedBox(height: 25),
              MyAuthTextField(
                controller: _usernameController,
                hintText: 'New Username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 25),
              MyButton(
                  onPressed: () async {
                    final shouldChange =
                        await showChangeUsernameDialog(context);
                    if (shouldChange) {
                      print(_usernameController.text.toString());
                    }
                  },
                  text: 'Changes Username')
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final shouldUpdate = await showChangeProfilePictureDialog(context);
      if (shouldUpdate) {
        print('uploadpicture');
      }
    }
  }
}
