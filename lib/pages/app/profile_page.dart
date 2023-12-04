import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_appbar.dart';
import 'package:locainfo/components/my_profile_listtile.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/routes.dart';
import 'package:locainfo/pages/app/profile_setting_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/services/profile/profile_bloc.dart';
import 'package:locainfo/services/profile/profile_event.dart';
import 'package:locainfo/services/profile/profile_state.dart';
import 'package:locainfo/utilities/dialog/logout_dialog.dart';
import 'package:locainfo/utilities/toast_message.dart';

// page for user to see their profile
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CurrentUser? user;

  @override
  void initState() {
    context.read<ProfileBloc>().add(const ProfileEventInitialiseProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is ProfileStateProfileInitialiseFail) {
          showToastMessage('Cannot fetch your detail at the moment');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const MyAppBar(
          title: 'Profile',
          needSearch: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileContainer(context),
            _buildProfileListTiles(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [AppColors.lightestBlue, AppColors.darkerBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkerBlue.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileStateProfileInitialised) {
            user = state.user;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfilePicture(state.user),
                const SizedBox(height: 15),
                _buildUserInfo(state.user),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProfilePicture(null),
                const SizedBox(height: 60),
              ],
            );
          }
        },
      ),
    );
  }

  // options for profile page
  Widget _buildProfileListTiles() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          MyProfileListTile(
            onTap: () {
              user != null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfilePage(user: user!),
                      ),
                    )
                  : showToastMessage('User cannot be identified');
            },
            leadingIcon: Icons.person,
            trailingIcon: Icons.arrow_right,
            title: 'Edit Profile',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: MyProfileListTile(
              onTap: () {
                Navigator.of(context).pushNamed(postedPostRoute);
              },
              leadingIcon: Icons.article,
              trailingIcon: Icons.arrow_right,
              title: 'Posted Post',
            ),
          ),
          MyProfileListTile(
            onTap: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              }
            },
            leadingIcon: Icons.logout,
            trailingIcon: Icons.arrow_right,
            title: 'Logout',
          ),
        ],
      ),
    );
  }

  // profile picture
  Widget _buildProfilePicture(CurrentUser? user) {
    return user?.profilePicLink != null
        ? GestureDetector(
            onTap: () {
              final imageProvider = Image.network(user!.profilePicLink!).image;
              showImageViewer(
                context,
                imageProvider,
                swipeDismissible: true,
                doubleTapZoomable: true,
              );
            },
            child: Container(
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  user!.profilePicLink!,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          )
        : Container(
            height: 120,
            width: 120,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const ClipOval(
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          );
  }

  // username and email
  Widget _buildUserInfo(CurrentUser user) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Hi, ${user.userName}",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: AppColors.grey2,
          ),
        ),
        Text(
          user.userEmail,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.grey2,
          ),
        ),
      ],
    );
  }
}
