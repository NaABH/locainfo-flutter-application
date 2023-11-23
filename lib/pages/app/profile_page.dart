import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/constants/app_colors.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/bloc/auth_bloc.dart';
import 'package:locainfo/services/auth/bloc/auth_event.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
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
        backgroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16), color: Colors.grey),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // profile picture
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(_firebaseAuthProvider.currentUserName!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
