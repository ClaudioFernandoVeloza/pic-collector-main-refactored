import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pic_collector/screens/main-features/chat_screen.dart';
import 'package:pic_collector/screens/main-features/friends_screen.dart';
import 'package:pic_collector/screens/main-features/home_screen.dart';
import 'package:pic_collector/screens/main-features/participation_screen.dart';
import 'package:pic_collector/screens/main-features/profile_screen.dart';

/// Root screen that holds the bottom navigation (the "screen picker")
/// and renders the currently selected tab.
class MenuOrchestrator extends StatefulWidget {
  const MenuOrchestrator({super.key});

  @override
  State<MenuOrchestrator> createState() => _MenuOrchestratorState();
}

class _MenuOrchestratorState extends State<MenuOrchestrator> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ParticipationScreen(),
    ChatScreen(),
    FriendsScreen(),
    ProfileScreen(),
  ];

  static const List<String> _titles = [
    'Pic Collector',
    'Participation',
    'Chat',
    'Friends',
    'Profile',
  ];

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          _selectedIndex == 0 ? 'Pic Collector' : _titles[_selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue,
                  child: Text(
                    user.email != null && user.email!.isNotEmpty
                        ? user.email![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Participation',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
