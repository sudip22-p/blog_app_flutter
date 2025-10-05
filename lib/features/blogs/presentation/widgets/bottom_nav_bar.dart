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
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
        return;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const ExploreBlogsScreen(),
          ),
        );
        return;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const FavouritesScreen(),
          ),
        );
        return;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const MyBlogsScreen(),
          ),
        );
        return;
    }
  }

  @override
  void initState() {
    _selectedIndex = widget.selection.clamp(0, 3); // Ensure valid range
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
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
      unselectedItemColor: const Color(0xff7d869a),
      selectedItemColor: Theme.of(context).colorScheme.primary,

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SizedBox(height: 24, width: 24, child: Icon(Icons.home)),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(height: 24, width: 24, child: Icon(Icons.explore)),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.my_library_books_outlined),
          label: 'My Blogs',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
