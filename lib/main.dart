import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/chat_screen.dart';
import 'package:test_app/screens/home_screen.dart';
import 'package:test_app/screens/messaging_screen.dart';
import 'package:test_app/screens/settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        initialRoute: "/",
        routes: {
          "/": (context) => MainScreen(),
          "/messaging": (context) => MessagingScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;
  int _titleIndex = 0;
  
  final List<String> _titles = ['Home', 'Chats', 'Settings'];
  final List<Widget> _screens = [
    HomeScreen(), // 0
    ChatScreen(), // 1
    SettingsScreen(), //2
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(8),
        title: Text(_titles[_titleIndex]),
        actions: [
          IconButton(
            icon: Icon(Icons.light_mode),
            onPressed: () {
              AdaptiveTheme.of(context).toggleThemeMode();
            },
        )],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _titleIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'), // 0
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'), // 1
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ), //2
        ],
      ),
    );
  }
}
