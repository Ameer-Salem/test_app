import 'package:flutter/material.dart';

class MainController extends ChangeNotifier {
  int _selectedIndex = 0;
  int _titleIndex = 0;
  
  final List<String> titles = ['Home', 'Chats', 'Settings'];
  
  int get selectedIndex => _selectedIndex;
  int get titleIndex => _titleIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    _titleIndex = index;
    notifyListeners();
  }
}
