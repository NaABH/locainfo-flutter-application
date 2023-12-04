// exception for post operation
class PostException implements Exception {
  const PostException();
}

// creating post
class TitleCouldNotEmptyPostException extends PostException {}

// creating post
class InvalidCategoryPostException extends PostException {}

// creating post
class ContentCouldNotEmptyPostException extends PostException {}

// creating posy
class InvalidContactPostException extends PostException {}

// reporting post
class ReasonCouldNotEmptyPostException extends PostException {}
