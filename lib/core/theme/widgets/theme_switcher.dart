import 'package:blog_app/core/theme/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitcher extends StatelessWidget {
  final bool showLabel;
  final IconData? lightIcon;
  final IconData? darkIcon;

  const ThemeSwitcher({
    super.key,
    this.showLabel = false,
    this.lightIcon,
    this.darkIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDark =
            state is DarkTheme ||
            (state is SystemTheme &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);

        if (showLabel) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDark
                    ? (darkIcon ?? Icons.dark_mode)
                    : (lightIcon ?? Icons.light_mode),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(isDark ? 'Dark Mode' : 'Light Mode'),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: isDark,
                onChanged: (value) {
                  context.read<ThemeBloc>().add(ThemeToggled());
                },
              ),
            ],
          );
        }

        return IconButton(
          onPressed: () {
            context.read<ThemeBloc>().add(ThemeToggled());
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isDark
                  ? (darkIcon ?? Icons.dark_mode)
                  : (lightIcon ?? Icons.light_mode),
              key: ValueKey(isDark),
            ),
          ),
        );
      },
    );
  }
}
