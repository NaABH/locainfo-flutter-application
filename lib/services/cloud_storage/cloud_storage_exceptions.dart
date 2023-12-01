// exceptions for storage service
class StorageException implements Exception {
  const StorageException();
}

class CouldNotUploadPostImageException extends StorageException {}

class CouldNotUploadProfileImageException extends StorageException {}
