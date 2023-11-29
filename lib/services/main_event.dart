import 'package:flutter/foundation.dart';

@immutable
abstract class MainEvent {
  const MainEvent();
}

class MainEventInitialise extends MainEvent {
  const MainEventInitialise();
}

class MainEventNavigationChanged extends MainEvent {
  final int index;
  const MainEventNavigationChanged({required this.index});
}

class MainEventViewPostedPosts extends MainEvent {
  const MainEventViewPostedPosts();
}
