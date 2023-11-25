class DatabaseException implements Exception {
  const DatabaseException();
}

// creating
class CouldNotCreatePostException extends DatabaseException {}

// reading
class CouldNotGetPostsException extends DatabaseException {}

// updating
class CouldNotUpdatePostException extends DatabaseException {}

// deleting
class CouldNotDeletePostException extends DatabaseException {}
