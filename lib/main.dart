import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/database_controller.dart';
import 'package:test_app/controllers/main_controller.dart';
import 'package:test_app/controllers/messaging_controller.dart';
import 'package:test_app/controllers/settings_controller.dart';
import 'package:test_app/models/app_database.dart';
import 'package:test_app/screens/ble_check.dart';
import 'package:test_app/screens/device_screen.dart';
import 'package:test_app/screens/main_screen.dart';
import 'package:test_app/screens/messaging_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  await Permission.location.request();
  final db = AppDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => MessagingController()),
        ChangeNotifierProvider(create: (_) => DatabaseController(db)),
      ],
      child: const MyApp(),
    ),
  );
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
          "/": (context) => BleCheckScreen(),
          "/main": (context) => MainScreen(),
          "/main/messaging": (context) => MessagingScreen(),
          "/main/device": (context) => DeviceScreen(),
        },
      ),
    );
  }
}
