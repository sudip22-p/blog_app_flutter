part of 'theme_bloc.dart';

sealed class ThemeEvent {}

class ThemeToggled extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;
  ThemeChanged(this.themeMode);
}
