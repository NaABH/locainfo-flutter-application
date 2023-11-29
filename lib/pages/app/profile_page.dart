import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/components/my_profile_listtile.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/main_bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/utilities/logout_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final FirebaseAuthProvider _firebaseAuthProvider;

  @override
  void initState() {
    _firebaseAuthProvider = FirebaseAuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
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
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hello, ${_firebaseAuthProvider.currentUserName!}",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey2),
                    ),
                    Text(
                      _firebaseAuthProvider.currentUser!.email,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey2),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                MyProfileListTile(
                    onTap: () {},
                    leadingIcon: Icons.person,
                    trailingIcon: Icons.arrow_right,
                    title: 'Profile Setting'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: MyProfileListTile(
                      onTap: () {
                        context
                            .read<MainBloc>()
                            .add(const MainEventViewPostedPosts());
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
    );
  }
}
