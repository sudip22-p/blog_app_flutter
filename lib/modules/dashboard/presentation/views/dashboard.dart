import 'package:blog_app/core/core.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/modules/dashboard/presentation/widgets/home_screen.dart';
import 'package:blog_app/modules/blogs/features/explore_all_blogs/presentation/views/explore_blogs_screen.dart';
import 'package:blog_app/modules/blogs/features/favourite_blogs/presentation/views/favourites_screen.dart';
import 'package:blog_app/modules/blogs/features/my_blogs_overview/presentation/views/my_blogs_screen.dart';

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
        icon: Icon(Icons.home_outlined),
        label: 'Home',
        selectedIcon: Icon(
          Icons.home_outlined,
          color: context.customTheme.primary,
        ),
      ),
      NavigationDestination(
        icon: Icon(Icons.explore_outlined),
        label: 'Explore',
        selectedIcon: Icon(
          Icons.explore_outlined,
          color: context.customTheme.primary,
        ),
      ),
      NavigationDestination(
        icon: Icon(Icons.favorite_outline),
        label: 'Favourites',
        selectedIcon: Icon(
          Icons.favorite_outline,
          color: context.customTheme.primary,
        ),
      ),
      NavigationDestination(
        icon: Icon(Icons.article_outlined),
        label: 'My Blogs',
        selectedIcon: Icon(
          Icons.article_outlined,
          color: context.customTheme.primary,
        ),
      ),
    ];
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: destinations,
      ),
    );
  }
}
