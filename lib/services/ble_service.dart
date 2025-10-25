import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  // BLE service implementation

  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _deviceServices = [];

  // Stram for scanning results
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  // Check Bluetooth state
  Stream<BluetoothAdapterState> get bluetoothState =>
      FlutterBluePlus.adapterState;

  // ====== SCAN ======
  Future<void> startScan({String serviceUuid = "12345678-1234-5678-1234-56789abcdef0",int timeoutSeconds = 5}) async {
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: timeoutSeconds),
      withServices: [Guid(serviceUuid)],
      
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // ====== CONNECT ======
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevice = device;
    _deviceServices = await device.discoverServices();
  }

  Future<void> disconnectDevice() async {
    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
      _deviceServices.clear();
    }
  }

  BluetoothDevice? get connectedDevice => _connectedDevice;

  // ====== READ / WRITE ======
  Future<void> writeToCharacteristic(
    Guid serviceUuid,
    Guid charUuid,
    List<int> value,
  ) async {
    final service = _deviceServices.firstWhere(
      (s) => s.uuid == serviceUuid,
      orElse: () => throw Exception("Service not found"),
    );
    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid == charUuid,
      orElse: () => throw Exception("Characteristic not found"),
    );
    final bytes = Uint8List.fromList(value);
    await characteristic.write(bytes); 
  }

  Future<List<int>> readFromCharacteristic(
    Guid serviceUuid,
    Guid charUuid,
  ) async {
    final service = _deviceServices.firstWhere(
      (s) => s.uuid == serviceUuid,
      orElse: () => throw Exception("Service not found"),
    );
    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid == charUuid,
      orElse: () => throw Exception("Characteristic not found"),
    );
    return await characteristic.read();
  }

  // ====== NOTIFICATIONS ======

  Future<void> listenToNotifications(
    Guid serviceUuid,
    Guid charUuid,
    void Function(List<int>) onData, 
  ) async {
    final service = _deviceServices.firstWhere(
      (s) => s.uuid == serviceUuid,
      orElse: () => throw Exception("Service not found"),
    );
    final characteristic = service.characteristics.firstWhere(
      (c) => c.uuid == charUuid,
      orElse: () => throw Exception("Characteristic not found"),
    );

    await characteristic.setNotifyValue(true);
    characteristic.onValueReceived.listen(onData);
  }

}
