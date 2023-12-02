class DatabaseException implements Exception {
  const DatabaseException();
}

//------------------------------------Post-----------------------------------
// creating post
class CouldNotCreatePostException extends DatabaseException {}

// reading nearby, posted post
class CouldNotGetPostsException extends DatabaseException {}

// reading bookmark id
class CouldNotGetBookmarkPostIdsException extends DatabaseException {}

// reading bookmark post
class CouldNotGetBookmarkPostException extends DatabaseException {}

// reading search result
class CouldNotGetSearchedPostException extends DatabaseException {}

// updating post
class CouldNotUpdatePostException extends DatabaseException {}

// updating post reactions
class CouldNotUpdatePostReactionsException extends DatabaseException {}

// updating bookmark post
class CouldNotClearBookmarkException extends DatabaseException {}

// deleting post
class CouldNotDeletePostException extends DatabaseException {}

//------------------------------------Report-----------------------------------
// creating report
class CouldNotCreateReportException extends DatabaseException {}

//------------------------------------User-----------------------------------
// creating user when first sign in
class CouldNotCreateNewUserException extends DatabaseException {}

// reading user (to get its id, name, email, profile picture link)
class CouldNotGetUserException extends DatabaseException {}

// updating user profile picture
class CouldNotUpdateProfilePictureException extends DatabaseException {}

// updating user name
class CouldNotUpdateUsernameException extends DatabaseException {}
