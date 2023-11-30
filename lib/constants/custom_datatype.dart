// Represent the type of interaction from user to the post
enum UserAction {
  like,
  unlike,
  dislike,
  removeDislike,
  bookmark,
  removeBookmark,
  clearBookmark,
}

// Represent the design of post that should be displayed
enum PostPatternType {
  home,
  news,
  bookmark,
  userPosted,
}
