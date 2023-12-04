import 'package:locainfo/services/firestore/post.dart';

// sort post
List<Post> sortPosts(List<Post> posts, String? selectedSortBy) {
  switch (selectedSortBy) {
    case 'Newest':
      return sortPostsByDate(posts);
    case 'Popular':
      return sortPostsByLikes(posts);
    case 'Nearest':
      return sortPostsByDistance(posts);
    default:
      return posts;
  }
}

// ascending order of distances from current location (nearer first)
List<Post> sortPostsByDistance(List<Post> posts) {
  return posts
    ..sort((a, b) {
      int compare = a.distance!.compareTo(b.distance!);
      if (compare != 0) {
        // distances are different, sort by distance
        return compare;
      } else {
        // distances are same, sort by posted date (newer first)
        return b.postedDate.compareTo(a.postedDate);
      }
    });
}

// descending order of number of likes (more like first)
List<Post> sortPostsByLikes(List<Post> posts) {
  return posts..sort((a, b) => b.numberOfLikes.compareTo(a.numberOfLikes));
}

// descending order of posted date (newer first)
List<Post> sortPostsByDate(List<Post> posts) {
  return posts.toList()..sort((a, b) => b.postedDate.compareTo(a.postedDate));
}

// filter post based on category
List<Post> filterPostsByCategory(List<Post> posts, String category) {
  return posts.where((post) => post.category == category).toList();
}
