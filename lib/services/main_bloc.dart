import 'package:bloc/bloc.dart';
import 'package:locainfo/services/main_event.dart';
import 'package:locainfo/services/main_state.dart';
import 'package:locainfo/utilities/weather_data.dart';

// the main bloc is used for navigation between different main pages of the application
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainStateInitialised()) {
    late MainState previousState;
    late String weather;

    on<MainEventInitialise>((event, emit) async {
      weather = await fetchWeatherData();
      emit(MainStateHome(weather));
    });

    on<MainEventNavigationChanged>((event, emit) async {
      switch (event.index) {
        case 0:
          weather = await fetchWeatherData();
          emit(MainStateHome(weather));
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

    // save previous state
    on<MainEventSavePreviousState>((event, emit) {
      previousState = state;
    });

    // go back to previous state
    on<MainEventBackToLastState>((event, emit) {
      emit(previousState);
    });
  }
}
