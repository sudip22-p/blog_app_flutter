import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeModeState> {
  ThemeCubit() : super(const ThemeModeState());
  void toggleTheme() {
    final nextMode = switch (state.themeMode) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      _ => ThemeMode.light,
    };
    emit(ThemeModeState(themeMode: nextMode));
  }

  @override
  ThemeModeState? fromJson(Map<String, dynamic> json) {
    return switch (json['themeMode']) {
      'ThemeMode.dark' => const ThemeModeState(themeMode: ThemeMode.dark),
      'ThemeMode.light' => const ThemeModeState(themeMode: ThemeMode.light),
      _ => const ThemeModeState(themeMode: ThemeMode.system),
    };
  }

  @override
  Map<String, String>? toJson(ThemeModeState state) {
    return <String, String>{'themeMode': state.themeMode.toString()};
  }
}
