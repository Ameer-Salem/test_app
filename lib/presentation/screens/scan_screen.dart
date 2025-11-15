import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/device_manager.dart';
import 'package:test_app/models/helpers/connection_state.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> devices = [];
  bool isScanning = false;
  StreamSubscription<List<ScanResult>>? scanResuts;

  @override
  void initState() {
    super.initState();
    final manager = Provider.of<DeviceManager>(context, listen: false);
    manager.scan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = Provider.of<DeviceManager>(context);
    String stateText;
    switch (manager.state) {
      case ConnectionStates.disconnected:
        stateText = "Disconnected";
        break;
      case ConnectionStates.connecting:
        stateText = "Connecting...";
        break;
      case ConnectionStates.connected:
        stateText = "Connected";
        break;
      case ConnectionStates.disconnecting:
        stateText = "Disconnecting...";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('BLE Scan'),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
          icon: Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop_rounded : Icons.search_rounded),
            onPressed: isScanning ? FlutterBluePlus.stopScan : manager.scan,
          ),
        ],
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBluePlus.scanResults,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No devices found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final result = snapshot.data![index];

              return ListTile(
                title: Text(
                  result.device.advName.isNotEmpty
                      ? result.device.advName
                      : 'Unknown Device',
                ),
                subtitle: Text(result.device.remoteId.toString()),
                onTap: () async {
                  await manager.connect(result.device);
                  if (context.mounted) Navigator.pushReplacementNamed(context, '/main');
                },
                trailing: Text(stateText),
              );
            },
          );
        },
      ),
    );
  }
}
