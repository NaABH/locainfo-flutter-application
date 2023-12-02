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

class MainEventSavePreviousState extends MainEvent {
  const MainEventSavePreviousState();
}

class MainEventBackToLastState extends MainEvent {
  const MainEventBackToLastState();
}
