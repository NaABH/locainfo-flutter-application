import 'package:flutter/foundation.dart';

@immutable
abstract class MainState {
  const MainState();
}

class MainStateHome extends MainState {
  const MainStateHome();
}

class MainStateNews extends MainState {
  const MainStateNews();
}

class MainStateBookmark extends MainState {
  const MainStateBookmark();
}

class MainStateProfile extends MainState {
  const MainStateProfile();
}

class MainStateNavigateToPage extends MainState {
  const MainStateNavigateToPage();
}
