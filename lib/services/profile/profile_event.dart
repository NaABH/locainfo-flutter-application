import 'dart:io';

abstract class ProfileEvent {
  const ProfileEvent();
}

// call in profile page when first enter
class ProfileEventInitialiseProfile extends ProfileEvent {
  const ProfileEventInitialiseProfile();
}

// call when update a profile picture
class ProfileEventUpdateProfilePicture extends ProfileEvent {
  final File image;
  const ProfileEventUpdateProfilePicture(this.image);
}

// call when update a username
class ProfileEventUpdateUsername extends ProfileEvent {
  final String newUsername;
  const ProfileEventUpdateUsername(this.newUsername);
}
