import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_app/models/helpers/packet_model.dart';
class BleService {
  BluetoothDevice? _connectedDevice;
  List<BluetoothService> _deviceServices = [];

  // ====== SCANNING ======
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;
  Stream<BluetoothAdapterState> get bluetoothState =>
      FlutterBluePlus.adapterState;

  Future<void> startScan({
    String serviceUuid = "12345678-1234-5678-1234-56789abcdef0",
    int timeoutSeconds = 5,
  }) async {
    await FlutterBluePlus.startScan(
      timeout: Duration(seconds: timeoutSeconds),
      withServices: [Guid(serviceUuid)],
    );
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  // ====== CONNECTION ======
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

  // ====== WRITE (Flutter → ESP32) ======
  Future<void> sendPacket(
    Guid serviceUuid,
    Guid rxCharacteristicUuid,
    Packet packet,
  ) async {
    final service = _deviceServices.firstWhere(
      (s) => s.uuid == serviceUuid,
      orElse: () => throw Exception("Service not found"),
    );
    final rxCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid == rxCharacteristicUuid,
      orElse: () => throw Exception("Characteristic not found"),
    );

    final bytes = Uint8List.fromList(packet.toBytes());
    await rxCharacteristic.write(bytes);
  }

  // ====== LISTEN (ESP32 → Flutter) ======
  Future<void> listenToNotifications(
    Guid serviceUuid,
    Guid txCharacteristicUuid,
    void Function(Packet packet) onPacketReceived,
  ) async {
    final service = _deviceServices.firstWhere(
      (s) => s.uuid == serviceUuid,
      orElse: () => throw Exception("Service not found"),
    );
    final txCharacteristic = service.characteristics.firstWhere(
      (c) => c.uuid == txCharacteristicUuid,
      orElse: () => throw Exception("Characteristic not found"),
    );

    await txCharacteristic.setNotifyValue(true);

    txCharacteristic.onValueReceived.listen((data) {
      if (data.isEmpty) return;
      try {
        final packet = Packet.fromBytes(data);
        onPacketReceived(packet);
      } catch (e) {
        print("⚠️ Invalid packet received: $e");
      }
    });
  }
}