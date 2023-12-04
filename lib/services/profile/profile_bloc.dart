import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locainfo/services/auth/firebase_auth_provider.dart';
import 'package:locainfo/services/cloud_storage/storage_provider.dart';
import 'package:locainfo/services/firestore/database_provider.dart';
import 'package:locainfo/services/profile/profile_event.dart';
import 'package:locainfo/services/profile/profile_exceptions.dart';
import 'package:locainfo/services/profile/profile_state.dart';
import 'package:locainfo/utilities/input_validation.dart';

// bloc to control profile data
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final DatabaseProvider _databaseProvider;
  final FirebaseAuthProvider _authProvider;
  final StorageProvider _cloudStorageProvider;

  ProfileBloc(
    this._databaseProvider,
    this._authProvider,
    this._cloudStorageProvider,
  ) : super(const ProfileStateInitial(isLoading: false)) {
    // initialise profile (profile page)
    on<ProfileEventInitialiseProfile>((event, emit) async {
      try {
        final user = await _databaseProvider.getUser(
            currentUserId: _authProvider.currentUser!.id);
        emit(ProfileStateProfileInitialised(isLoading: false, user: user));
      } on Exception catch (_) {
        emit(const ProfileStateProfileInitialiseFail(isLoading: false));
      }
    });

    // update profile picture (post setting page)
    on<ProfileEventUpdateProfilePicture>((event, emit) async {
      String? imageUrl;
      try {
        emit(const ProfileStateUpdatingPicture(
            isLoading: true, loadingText: 'Updating profile picture'));
        imageUrl = await _cloudStorageProvider.uploadProfileImage(event.image);
        await _authProvider.updateProfilePicUrl(imageUrl);
        await _databaseProvider.updateProfilePicture(
            currentUserId: _authProvider.currentUser!.id, imageUrl: imageUrl);
        emit(const ProfileStateUpdatingPicture(isLoading: false));
        emit(ProfileStateUpdatePictureSuccessfully(
          isLoading: false,
          imageUrl: imageUrl,
        ));
      } on Exception catch (e) {
        emit(const ProfileStateUpdatingPicture(isLoading: false));
        emit(ProfileStateUpdatePictureError(isLoading: false, exception: e));
      }
    });

    // update username (post setting page)
    on<ProfileEventUpdateUsername>((event, emit) async {
      try {
        if (!isInputValid(event.newUsername)) {
          throw UsernameCouldNotBeEmptyProfileException();
        }
        emit(const ProfileStateUpdatingUsername(
            isLoading: true, loadingText: 'Updating username'));
        await _authProvider.updateDisplayName(event.newUsername);
        await _databaseProvider.updateUsername(
            currentUserId: _authProvider.currentUser!.id,
            newUsername: event.newUsername);
        emit(const ProfileStateUpdatingUsername(isLoading: false));
        emit(const ProfileStateUpdateUsernameSuccessfully(isLoading: false));
      } on Exception catch (e) {
        emit(const ProfileStateUpdatingUsername(isLoading: false));
        emit(ProfileStateUpdateUsernameError(isLoading: false, exception: e));
      }
    });
  }
}
