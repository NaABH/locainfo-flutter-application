import 'package:flutter/foundation.dart';
import 'package:locainfo/services/firestore/post.dart';

@immutable
abstract class DatabaseState {
  final Exception? exception;
  const DatabaseState({required this.exception});
}

class DatabaseStateUninitialized extends DatabaseState {
  const DatabaseStateUninitialized() : super(exception: null);
}

class DatabaseStateLoadingPost extends DatabaseState {
  const DatabaseStateLoadingPost() : super(exception: null);
}

class DatabaseStateNewsPagePostFetched extends DatabaseState {
  final Iterable<Post> posts;
  const DatabaseStateNewsPagePostFetched({required this.posts})
      : super(exception: null);
}
