import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class MainState extends Equatable {
  const MainState();
}

class MainStateHome extends MainState {
  const MainStateHome();

  @override
  List<Object?> get props => [];
}

class MainStateNews extends MainState {
  const MainStateNews();

  @override
  List<Object?> get props => [];
}

class MainStateBookmark extends MainState {
  const MainStateBookmark();

  @override
  List<Object?> get props => [];
}

class MainStateProfile extends MainState {
  const MainStateProfile();

  @override
  List<Object?> get props => [];
}
