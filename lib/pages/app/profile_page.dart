import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_profile_listtile.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/pages/app/posted_posts_page.dart';
import 'package:locainfo/pages/app/profile_setting_page.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/firestore/current_user.dart';
import 'package:locainfo/services/post/post_bloc.dart';
import 'package:locainfo/services/post/post_event.dart';
import 'package:locainfo/services/post/post_state.dart';
import 'package:locainfo/utilities/dialog/logout_dialog.dart';
import 'package:locainfo/utilities/toast_message.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CurrentUser? user;
  @override
  void initState() {
    context.read<PostBloc>().add(const PostEventInitialiseProfile());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostStateProfileInitialiseFail) {
          showToastMessage('Cannot fetch your detail at the moment');
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          title: Row(
            children: [
              Text(
                'Profile',
                style: CustomFontStyles.appBarTitle,
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.darkerBlue,
                  size: 26,
                )),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  if (state is PostStateProfileInitialised) {
                    user = state.user;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // profile picture
                        state.user.profilePicLink != null
                            ? GestureDetector(
                                onTap: () {
                                  final imageProvider =
                                      Image.network(state.user.profilePicLink!)
                                          .image;
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
                                      state.user.profilePicLink!,
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
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hello, ${state.user.userName}",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey2),
                            ),
                            Text(
                              state.user.userEmail,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey2),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // profile picture
                        Container(
                            height: 120,
                            width: 120,
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hello, User",
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grey2),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  MyProfileListTile(
                      onTap: () {
                        user != null
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateProfilePage(user: user!),
                                ),
                              )
                            : showToastMessage('User cannot be identified');
                      },
                      leadingIcon: Icons.person,
                      trailingIcon: Icons.arrow_right,
                      title: 'Edit Profile'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: MyProfileListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PostedPostsPage(),
                            ),
                          );
                        },
                        leadingIcon: Icons.article,
                        trailingIcon: Icons.arrow_right,
                        title: 'Posted Post'),
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
                      title: 'Logout'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
