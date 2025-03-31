import 'package:csefamily/Entry/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:csefamily/theme/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize theme provider and load preferences
  final themeProvider = ThemeProvider();
  await themeProvider.loadThemePreference();

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        // Customize light theme if needed
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        // Customize dark theme if needed
        primaryColor: Colors.blue[800],
        appBarTheme: AppBarTheme(
          color: Colors.blue[800],
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const LoginPage(),
    );
  }
}