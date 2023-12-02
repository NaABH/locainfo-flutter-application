import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/current_user.dart';

@immutable
abstract class ProfileState {
  final bool isLoading;
  final String? loadingText;
  const ProfileState({required this.isLoading, this.loadingText = 'Loading..'});
}

// when being initialise
class ProfileStateInitial extends ProfileState {
  const ProfileStateInitial({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when fetch current user successfully in profile page
class ProfileStateProfileInitialised extends ProfileState {
  final CurrentUser user;
  const ProfileStateProfileInitialised(
      {required bool isLoading, required this.user})
      : super(isLoading: isLoading);
}

// emitted when face error when fetching user details
class ProfileStateProfileInitialiseFail extends ProfileState {
  const ProfileStateProfileInitialiseFail({required bool isLoading})
      : super(isLoading: isLoading);
}

// emitted when updating profile picture
class ProfileStateUpdatingPicture extends ProfileState {
  const ProfileStateUpdatingPicture(
      {required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when error when updating profile picture
class ProfileStateUpdatePictureError extends ProfileState {
  final Exception? exception;
  const ProfileStateUpdatePictureError(
      {required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

// emitted when update profile picture successfully
class ProfileStateUpdatePictureSuccessfully extends ProfileState {
  final String imageUrl;
  const ProfileStateUpdatePictureSuccessfully({
    required bool isLoading,
    required this.imageUrl,
  }) : super(isLoading: isLoading);
}

// emitted when updating username
class ProfileStateUpdatingUsername extends ProfileState {
  const ProfileStateUpdatingUsername(
      {required bool isLoading, String? loadingText})
      : super(isLoading: isLoading, loadingText: loadingText);
}

// emitted when error when updating username
class ProfileStateUpdateUsernameError extends ProfileState {
  final Exception? exception;
  const ProfileStateUpdateUsernameError(
      {required bool isLoading, required this.exception})
      : super(isLoading: isLoading);
}

// emitted when update username successfully
class ProfileStateUpdateUsernameSuccessfully extends ProfileState {
  const ProfileStateUpdateUsernameSuccessfully({required bool isLoading})
      : super(isLoading: isLoading);
}
