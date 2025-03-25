// ignore: file_names
import 'package:flutter/material.dart';
import 'Account_Profile.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, color: Colors.black),
      onSelected: (value) {
        if (value == 'profile') {
          _navigateToProfile(context);
        } else if (value == 'dark') {
          _toggleDarkMode(context);
        } else if (value == 'settings') {
          _navigateToSettings(context);
        } else if (value == 'logout') {
          _handleLogout(context);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.black),
              SizedBox(width: 10),
              Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'dark',
          child: Row(
            children: [
              Icon(Icons.dark_mode, color: Colors.black),
              SizedBox(width: 10),
              Text("Dark Mode"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: Colors.black),
              SizedBox(width: 10),
              Text("Settings"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 10),
              Text("Logout"),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAccountPage()), // Navigate to MyAccountPage
    );
  }

  void _toggleDarkMode(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dark Mode Toggled")),
    );
  }

  void _navigateToSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Navigating to Settings...")),
    );
  }

  void _handleLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logging Out...")),
    );
  }
}
