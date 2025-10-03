import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_app/screens/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScanScreen();
  }
}
