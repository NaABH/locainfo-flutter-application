import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageProvider {
  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    // Create a reference to the storage path with a unique name (timestamp)
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toString()}');

    // Upload the file to Firebase Cloud Storage
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Wait for the upload to complete and get the task snapshot
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    // Return the download URL of the uploaded file
    return await taskSnapshot.ref.getDownloadURL();
  }
}
