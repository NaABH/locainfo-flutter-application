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

class CouldNotGetBookmarkPostIdsException extends DatabaseException {}

class CouldNotGetBookmarkPostException extends DatabaseException {}

class CouldNotGetSearchedPostException extends DatabaseException {}

class CouldClearBookmarkException extends DatabaseException {}

class CouldNotCreateReportException extends DatabaseException {}

class CouldNotCreateNewUserException extends DatabaseException {}

class CouldNotGetUserException extends DatabaseException {}
