import 'package:blog_app/core/core.dart';
import 'package:blog_app/modules/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/modules/blogs/blogs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreBlogsScreen(),
    FavouritesScreen(),
    MyBlogsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: Icon(
          Icons.home_outlined,
          color: context.customTheme.contentPrimary,
        ),
        label: 'Home',
        selectedIcon: Icon(
          Icons.home_outlined,
          color: context.customTheme.primary,
        ),
      ),

      NavigationDestination(
        icon: Icon(
          Icons.explore_outlined,
          color: context.customTheme.contentPrimary,
        ),
        label: 'Explore',
        selectedIcon: Icon(
          Icons.explore_outlined,
          color: context.customTheme.primary,
        ),
      ),

      NavigationDestination(
        icon: Icon(
          Icons.favorite_outline,
          color: context.customTheme.contentPrimary,
        ),
        label: 'Favourites',
        selectedIcon: Icon(
          Icons.favorite_outline,
          color: context.customTheme.primary,
        ),
      ),

      NavigationDestination(
        icon: Icon(
          Icons.article_outlined,
          color: context.customTheme.contentPrimary,
        ),
        label: 'My Blogs',
        selectedIcon: Icon(
          Icons.article_outlined,
          color: context.customTheme.primary,
        ),
      ),
    ];
    return Scaffold(
      backgroundColor: context.customTheme.background,
      body: BlogEngagementInitializer(
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),

      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            context.textTheme.bodySmall?.copyWith(
              color: context.customTheme.contentPrimary,
            ),
          ),
        ),
        child: NavigationBar(
          backgroundColor: context.customTheme.background,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) =>
              setState(() => _currentIndex = index),
          destinations: destinations,
        ),
      ),
    );
  }
}
