import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/device_manager.dart';
import 'package:test_app/logic/main_controller.dart';
import 'package:test_app/logic/messaging_controller.dart';
import 'package:test_app/logic/settings_controller.dart';
import 'package:test_app/presentation/screens/ble_check.dart';
import 'package:test_app/presentation/screens/device_screen.dart';
import 'package:test_app/presentation/screens/main_screen.dart';
import 'package:test_app/presentation/screens/scan_screen.dart';
import 'package:test_app/services/ble_service.dart';
import 'package:test_app/services/database_service.dart';
import 'package:test_app/services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.bluetoothScan.request();
  await Permission.bluetoothConnect.request();
  await Permission.location.request();

  final bleService = BleService();
  final dbService = DatabaseService();
  final storageService = StorageService();

  final deviceManager = DeviceManager(
    bleService: bleService,
    dbService: dbService,
    storageService: storageService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(create: (_) => MessagingController()),
        ChangeNotifierProvider(create:  (_) => deviceManager),
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
          "/device": (context) =>  DeviceScreen(),
          "/scan": (context) =>  ScanScreen(),
        },
      ),
    );
  }
}
