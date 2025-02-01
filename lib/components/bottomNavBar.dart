import 'package:flutter/material.dart';
import 'package:newsweather_app/ForyouPage.dart';
import 'package:newsweather_app/ProfilePage.dart';
import 'package:newsweather_app/explore.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = const Foryoupage();
        break;
      case 1:
        nextScreen = const ExploreScreen();
        break;
      case 3:
        nextScreen = const ProfilePage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 35,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.travel_explore,
            size: 35,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book_online,
            size: 35,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: 'Bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 35,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
