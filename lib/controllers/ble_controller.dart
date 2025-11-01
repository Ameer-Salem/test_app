import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_app/models/app_database.dart';
import 'package:test_app/models/helpers/packet_model.dart';
import 'package:test_app/services/ble_service.dart';
import 'package:test_app/services/message_service.dart';

class BleController extends ChangeNotifier {
  final Guid serviceUuid = Guid("12345678-1234-5678-1234-56789abcdef0");
  final Guid rxCharacteristicUuid = Guid(
    "12345678-1234-5678-1234-56789abcdef1",
  );
  final Guid txCharacteristicUuid = Guid(
    "12345678-1234-5678-1234-56789abcdef2",
  );

  final AppDatabase _db;
  MessageService get service => MessageService(_db);

  final BleService _bleService = BleService();
  bool isScanning = false;
  bool isConnecting = false;
  bool isConnected = false;
  BluetoothDevice? connectedDevice;

  List<ScanResult> scanResults = [];
  List<BluetoothDevice> connectedDevices = [];

  Stream<BluetoothAdapterState> get state => _bleService.bluetoothState;

  BleController(this._db) {
    // Listen for scan state changes (automatically updates when timeout ends)
    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning = scanning;
      notifyListeners();
    });

    // Keep listening to scan results
    _bleService.scanResults.listen((results) {
      scanResults = results;
      notifyListeners();
    });
  }

  // ====== SCANNING ======
  Future<void> startScan({int timeoutSeconds = 5}) async {
    await _bleService.startScan(timeoutSeconds: timeoutSeconds);
  }

  Future<void> stopScan() async {
    await _bleService.stopScan();
  }

  // ====== CONNECT ======
  Future<void> connect(BluetoothDevice device) async {
    isConnecting = true;
    notifyListeners();

    try {
      await _bleService.connectToDevice(device);
      connectedDevice = device;
      connectedDevices.add(device);
      isConnected = true;

      _bleService.listenToNotifications(serviceUuid, txCharacteristicUuid, (
        packet,
      ) async {
        if (packet.type == 0) {
          // Ack
          print("Ack received for seq: ${packet.sequence}");
        } else if (packet.type == 1) {
          // Text message
          service.addMessage(
            senderId: 2,
            receiverId: packet.destination,
            content: String.fromCharCodes(packet.payload),
            type: "text",
          );
          print("Text: ${String.fromCharCodes(packet.payload)}");
        }
      });
    } catch (e) {
      isConnected = false;
    } finally {
      isConnecting = false;
      notifyListeners();
    }
  }

  // ====== DISCONNECT ======
  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await _bleService.disconnectDevice();
      connectedDevices.clear();
      connectedDevice = null;
      isConnected = false;
      notifyListeners();
    }
  }
  
  // ===== MESSAGES ======
  int sequenceNumber = 0;
  Future<void> sendText(String message, {int destination = 2 }) async {

    if (connectedDevice == null) throw Exception("No device connected");

    final bytes = utf8.encode(message);

    final packet = Packet(
      type: 1,
      source: 1,
      destination: destination,
      sequence: sequenceNumber++,
      length: bytes.length,
      payload: bytes,
    );

    await _bleService.sendPacket(serviceUuid, rxCharacteristicUuid, packet);

    service.addMessage(
      senderId: packet.source,
      receiverId: packet.destination,
      content: message,
      type: "text",
    );
  }
}
