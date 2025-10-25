
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/main_controller.dart';
import 'package:test_app/presentation/screens/chat_screen.dart';
import 'package:test_app/presentation/screens/home_screen.dart';
import 'package:test_app/presentation/screens/settings_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

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
        title: Consumer<MainController>(
          builder: (context, controller, child) {
            return Text(
              controller.titles[controller.titleIndex],
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[context.watch<MainController>().selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<MainController>().selectedIndex,
        onTap: (index) {
          context.read<MainController>().changeIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ), // 0
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: '',
          ), // 1
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: '',
          ), //2
        ],
      ),
    );
  }
}
