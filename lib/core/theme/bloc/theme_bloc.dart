import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const SystemTheme()) {
    on<ThemeToggled>(onThemeToggled);
    on<ThemeChanged>(onThemeChanged);
  }

  void onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    if (state is LightTheme) {
      emit(const DarkTheme());
    } else if (state is DarkTheme) {
      emit(const LightTheme());
    } else {
      // default: light theme
      emit(const LightTheme());
    }
  }

  void onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    switch (event.themeMode) {
      case ThemeMode.light:
        emit(const LightTheme());
        break;
      case ThemeMode.dark:
        emit(const DarkTheme());
        break;
      case ThemeMode.system:
        emit(const SystemTheme());
        break;
    }
  }
}
