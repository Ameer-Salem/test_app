import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/device_manager.dart';
import 'package:test_app/models/helpers/connection_state.dart';
import 'package:test_app/presentation/screens/device_screen.dart';
import 'package:test_app/presentation/screens/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DeviceScreen();
  }
}
