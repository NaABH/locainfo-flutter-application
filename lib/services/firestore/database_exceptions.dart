class DatabaseException implements Exception {
  const DatabaseException();
}

// create
class CouldNotCreatePostException extends DatabaseException {}

// read
class CouldNotGetAllPostsException extends DatabaseException {}

// update
class CouldNotUpdatePostException extends DatabaseException {}

// delete
class CouldNotDeletePostException extends DatabaseException {}
