import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:locainfo/services/cloud_storage/cloud_storage_exceptions.dart';
import 'package:locainfo/services/cloud_storage/storage_provider.dart';
import 'package:uuid/uuid.dart';

// implementation for storagge provider
class CloudStorageProvider extends StorageProvider {
  // use for saving post image
  @override
  Future<String> uploadPostImage(File imageFile) async {
    try {
      String uniqueId = const Uuid().v4();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('post_images/${DateTime.now().toString()}_$uniqueId');
      // Upload the file to Firebase Cloud Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Wait for the upload to complete and get the task snapshot
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      // Return the download URL of the uploaded file
      return await taskSnapshot.ref.getDownloadURL();
    } on Exception catch (_) {
      throw CouldNotUploadPostImageException();
    }
  }

  // use for saving profile picture
  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String uniqueId = const Uuid().v4();
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().toString()}_$uniqueId');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } on Exception catch (_) {
      throw CouldNotUploadProfileImageException();
    }
  }
}
