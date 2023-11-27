class PostException implements Exception {
  const PostException();
}

class TitleCouldNotEmptyPostException extends PostException {}

class CategoryInvalidPostException extends PostException {}

class ContentCouldNotEmptyPostException extends PostException {}
