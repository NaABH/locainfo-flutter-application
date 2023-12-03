import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class MainState extends Equatable {
  const MainState();
}

class MainStateInitialised extends MainState {
  const MainStateInitialised();

  @override
  List<Object?> get props => [];
}

class MainStateHome extends MainState {
  final String weatherInformation;
  const MainStateHome(this.weatherInformation);

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
