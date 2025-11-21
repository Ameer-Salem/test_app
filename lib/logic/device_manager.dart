import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_app/models/helpers/connection_state.dart';
import 'package:test_app/services/ble_service.dart';
import 'package:test_app/services/database_service.dart';
import 'package:test_app/services/storage_service.dart';

class DeviceManager extends ChangeNotifier {
  final IBleService bleService;
  final IDatabaseService dbService;
  final StorageService storageService;

  BluetoothDevice? device;
  ConnectionStates state = ConnectionStates.disconnected;
  List<ScanResult> devices = [];

  late final StreamSubscription<List<ScanResult>> scanSubscription;

  DeviceManager({
    required this.bleService,
    required this.dbService,
    required this.storageService,
  }) {
    scanSubscription = bleService.scanResults.listen((results) {
      devices = results;
      notifyListeners();
    }, onDone: () => scanSubscription.cancel());
  }

  Future<void> init() async {
    final lastDeviceId = await storageService.getLastDeviceId();
    if (lastDeviceId != null &&
        devices.any(
          (d) =>
              int.parse(
                d.device.remoteId.toString().replaceAll(':', ''),radix: 16
              ) ==
              int.parse(lastDeviceId),
        )) {
      await connectToDeviceById(lastDeviceId);
    }
  }

  Future<void> connectToDeviceById(String lastDeviceId) async {
    state = ConnectionStates.connecting;
    final int lastDeviceIdInt = int.parse(lastDeviceId);
    final target = devices.firstWhere(
      (r) => int.parse(r.device.remoteId.toString().replaceAll(':', '') , radix: 16) == lastDeviceIdInt,
      orElse: () => throw Exception('Device not found'),
    );
    await connect(target.device);
  }

  Future<void> connect(BluetoothDevice target) async {
    state = ConnectionStates.connecting;
    notifyListeners();
    await bleService.connectToDevice(target);
    final deviceId = await bleService.readDeviceId(target);
    bleService.connectedDeviceId = deviceId;
    await dbService.closeDatabase();

    await dbService.openDatabase(deviceId);

    await storageService.saveLastDeviceId(deviceId);

    device = target;
    state = ConnectionStates.connected;
    notifyListeners();
  }

  Future<void> disconnect() async {
    if (device != null) {
      state = ConnectionStates.disconnecting;
      await bleService.disconnectToDevice(device!);
      await dbService.closeDatabase();
      await storageService.clearLastDeviceId();
      device = null;
      state = ConnectionStates.disconnected;
    }
  }

  Future<void> scan({Duration timeout = const Duration(seconds: 15)}) async {
    await bleService.startScan(timeout: timeout);
  }
}
