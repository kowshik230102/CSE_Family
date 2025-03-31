import 'package:csefamily/Entry/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:csefamily/theme/theme_provider.dart';
import 'my_account_page.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
      onSelected: (value) {
        if (value == 'profile') {
          _navigateToProfile(context);
        } else if (value == 'dark') {
          themeProvider.toggleTheme();
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
              Icon(Icons.person, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 10),
              const Text("Profile"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'dark',
          child: Row(
            children: [
              Icon(
                themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 10),
              Text(themeProvider.isDark ? "Light Mode" : "Dark Mode"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 10),
              const Text("Settings"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 10),
              const Text("Logout"),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyAccountPage()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Navigating to Settings...")),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
