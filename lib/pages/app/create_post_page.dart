import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:locainfo/components/my_back_button.dart';
import 'package:locainfo/components/my_button.dart';
import 'package:locainfo/components/my_dropdown_menu.dart';
import 'package:locainfo/constants/font_styles.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/firestore/firestore_provider.dart';
import 'package:locainfo/services/location/location_provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late final FireStoreProvider _databaseProvider;
  late final LocationProvider _locationProvider;
  late final TextEditingController _textControllerTitle;
  late final TextEditingController _textControllerBody;
  Position? _currentLocation;
  String? selectedValue;

  @override
  void initState() {
    _databaseProvider = FireStoreProvider();
    _locationProvider = LocationProvider();
    _textControllerTitle = TextEditingController();
    _textControllerBody = TextEditingController();
    _getCurrentLocation();
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
      selectedValue = value;
    });
  }

  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = position;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    DateTime postedTime = DateTime.now();
    Timestamp postedTimestamp = Timestamp.fromDate(postedTime);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          leading: MyBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Create Post',
            style: CustomFontStyles.appBarTitle,
          )),
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
                    TextField(
                      controller: _textControllerBody,
                      obscureText: false,
                      enableSuggestions: true,
                      autocorrect: true,
                      maxLines: 4,
                      maxLength: 150,
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
                  ],
                ),
              ),
              const SizedBox(height: 20),
              MyDropdownMenu(onValueChange: handleValueChange),
              const SizedBox(height: 20),
              TextField(
                obscureText: false,
                enableSuggestions: true,
                autocorrect: true,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  hintText: "Source",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                  onPressed: () async {
                    _databaseProvider.createNewPost(
                      ownerUserId: FirebaseAuthProvider().currentUser!.id,
                      ownerUserName: user?.displayName ?? 'Anonymous',
                      title: _textControllerTitle.text,
                      body: _textControllerBody.text,
                      category: selectedValue!,
                      latitude: _currentLocation!.latitude,
                      longitude: _currentLocation!.longitude,
                      postedDate: postedTimestamp,
                    );
                    Navigator.of(context).pop();
                  },
                  text: 'Submit'),
            ],
          ),
        ),
      ),
    );
  }
}
