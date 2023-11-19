import 'package:bloc/bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainStateHome()) {
    on<MainEventInitialise>((event, emit) => emit(const MainStateHome()));
    on<MainEventNavigationChanged>((event, emit) {
      switch (event.index) {
        case 0:
          emit(const MainStateHome());
          break;
        case 1:
          emit(const MainStateNews());
          break;
        case 2:
          emit(const MainStateBookmark());
          break;
        case 3:
          emit(const MainStateProfile());
          break;
      }
    });
  }
}
