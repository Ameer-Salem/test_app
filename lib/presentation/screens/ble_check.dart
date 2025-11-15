import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/device_manager.dart';

class BleCheckScreen extends StatefulWidget {
  const BleCheckScreen({super.key});

  @override
  State<BleCheckScreen> createState() => _BleCheckScreenState();
}

class _BleCheckScreenState extends State<BleCheckScreen> {
  // Checklist results (null = pending, true/false = result)
  bool? _platformSupported;
  BluetoothAdapterState? adapterState = BluetoothAdapterState.unknown;
  StreamSubscription<BluetoothAdapterState>? adapterStateSubscription;

  @override
  void initState() {
    super.initState();
    _runChecks();
    adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (mounted) {
        setState(() {
          adapterState = state;
        });
      }
    });
  }

  Future<void> _runChecks() async {
    // Step 1: Platform supported
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        bool supported = await FlutterBluePlus.isSupported;
        setState(() => _platformSupported = supported);
      } catch (_) {
        setState(() => _platformSupported = false);
      }
    } else {
      setState(() => _platformSupported = false);
    }
  }

  Widget _buildCheckTile(String title, bool? value) {
    Widget trailing;
    if (value == null) {
      trailing = const SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    } else if (value) {
      trailing = const Icon(Icons.check_circle, color: Colors.green);
    } else {
      trailing = const Icon(Icons.cancel, color: Colors.red);
    }

    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: trailing,
    );
  }

  @override
  void dispose() {
    adapterStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool bluetoothOn = adapterState == BluetoothAdapterState.on;
    bool allGood = _platformSupported == true && bluetoothOn;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            _buildCheckTile("Platform supported", _platformSupported),
            _buildCheckTile("Bluetooth turned on", bluetoothOn),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.1),
            if (allGood)
              ElevatedButton(
                onPressed: () async {
                  // Navigate to your scanner screen
                  await Provider.of<DeviceManager>(
                    context,
                    listen: false,
                  ).init();
                  if (context.mounted)
                    Navigator.pushReplacementNamed(context, "/main");
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              )
            else if (_platformSupported == false)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "This device does not support Bluetooth Low Energy. "
                  "The app cannot continue.",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else if (bluetoothOn == false)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Bluetooth is turned off. Please enable it to continue.",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
