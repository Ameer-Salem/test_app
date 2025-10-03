import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> scanResult = [];
  bool isScanning = false;
  late StreamSubscription<List<ScanResult>> scanResultSubscription;
  late StreamSubscription<bool> isScanningSubscription;

  @override
  void dispose() {
    scanResultSubscription.cancel();
    isScanningSubscription.cancel();
    super.dispose();
  }

  void startScan() async {
    await FlutterBluePlus.startScan(
      // match any of the specified services
      timeout: Duration(seconds: 8),
      webOptionalServices: [],
    );
  }

  @override
  void initState() {
    super.initState();
    scanResultSubscription = FlutterBluePlus.scanResults.listen(
      (result) {
        if (mounted) {
          setState(() {
            scanResult = result;
          });
        }
      },
      onError: (e) {
        print("Scan Error: $e");
      },
    );
    isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      if (mounted) {
        setState(() {
          isScanning = state;
        });
      }
    });
  }
  void onConnectPressed(BluetoothDevice device) {
    device.connect();

  }
  Iterable<Widget> buildScanResultTiles() {
    return scanResult.map(
      (r) => ListTile(
        title: Text(
          r.advertisementData.advName.isNotEmpty
              ? r.advertisementData.advName
              : "Unknown Device",
          style: TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${r.rssi}dBm ",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),

            Text(
              r.device.remoteId.toString(),
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(child: Icon(Icons.bluetooth)),
          ],
        ),
        trailing: TextButton(onPressed: () {}, child: Text('Connect')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: isScanning ? null : startScan,
            child: Text(isScanning ? 'Scanning...' : 'Start Scan'),
          ),
        ],
      ),
      body: Column(children: [...buildScanResultTiles()]),
    );
  }
}
