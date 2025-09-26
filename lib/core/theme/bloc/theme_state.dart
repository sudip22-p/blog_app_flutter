part of 'theme_bloc.dart';

sealed class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class LightTheme extends ThemeState {
  const LightTheme() : super(ThemeMode.light);
}

class DarkTheme extends ThemeState {
  const DarkTheme() : super(ThemeMode.dark);
}

class SystemTheme extends ThemeState {
  const SystemTheme() : super(ThemeMode.system);
}
