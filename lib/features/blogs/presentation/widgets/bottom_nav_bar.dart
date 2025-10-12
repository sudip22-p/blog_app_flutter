import "package:blog_app/features/auth/presentation/screens/home_screen.dart";
import "package:blog_app/features/blogs/presentation/screens/explore_blogs_screen.dart";
import "package:blog_app/features/blogs/presentation/screens/favourites_screen.dart";
import "package:blog_app/features/blogs/presentation/screens/my_blogs_screen.dart";
import "package:flutter/material.dart";

class BottomNavBar extends StatefulWidget {
  final int selection;
  const BottomNavBar({super.key, required this.selection});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Widget targetScreen;
    switch (_selectedIndex) {
      case 0:
        targetScreen = const HomeScreen();
        break;
      case 1:
        targetScreen = const ExploreBlogsScreen();
        break;
      case 2:
        targetScreen = const FavouritesScreen();
        break;
      case 3:
        targetScreen = const MyBlogsScreen();
        break;
      default:
        targetScreen = const HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => targetScreen),
    );
  }

  @override
  void initState() {
    _selectedIndex = widget.selection.clamp(0, 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: const Color(0xff7d869a),
      selectedIconTheme: const IconThemeData(opacity: 1.0),
      unselectedIconTheme: const IconThemeData(opacity: 1.0),
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: SizedBox(height: 24, width: 24, child: Icon(Icons.home)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(height: 24, width: 24, child: Icon(Icons.explore)),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 24,
            width: 24,
            child: Icon(Icons.favorite_outline),
          ),
          activeIcon: SizedBox(
            height: 24,
            width: 24,
            child: Icon(Icons.favorite),
          ),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 24,
            width: 24,
            child: Icon(Icons.my_library_books_outlined),
          ),
          label: 'My Blogs',
        ),
      ],
    );
  }
}
