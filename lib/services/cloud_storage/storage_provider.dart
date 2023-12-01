import 'dart:io';

abstract class StorageProvider {
  Future<String> uploadPostImage(File imageFile);
  Future<String> uploadProfileImage(File imageFile);
}
