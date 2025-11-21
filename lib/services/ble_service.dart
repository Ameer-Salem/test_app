import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:test_app/models/helpers/packet_model.dart';

abstract class IBleService {
  Stream<List<ScanResult>> get scanResults;
  int get connectedDeviceId;
  set connectedDeviceId(int x);
  Future<void> startScan({Duration timeout = const Duration(seconds: 15)});
  Future<void> connectToDevice(BluetoothDevice device);
  Future<void> disconnectToDevice(BluetoothDevice device);
  Future<int> readDeviceId(BluetoothDevice device);
  Future<void> sendSegment({
    required int type,
    required int sourceId,
    required int destinationId,
    required int uid,
    required int segmentIndex,
    required int totalSegments,
    required Uint8List data,
  });
  Future<void> sendAck({
    required int type,
    required int sourceId,
    required int destinationId,
    required int segmentIndex,
    required int uid,
  });
}

class BleService implements IBleService {
  Guid serviceGUID = Guid('ffffffff-ffff-ffff-ffff-ffffffffffff');
  Guid notifyGUID = Guid('ffffffff-ffff-ffff-ffff-fffffffffff0');
  Guid writeGUID = Guid('ffffffff-ffff-ffff-ffff-fffffffff000');
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  BluetoothCharacteristic? readCharacteristic;

  final StreamController<Uint8List> _incomingContoller =
      StreamController.broadcast();

  Stream<Uint8List> get incomingMessages => _incomingContoller.stream;

  @override
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  int _connectedDeviceId = 0;
  @override
  int get connectedDeviceId => _connectedDeviceId;
  @override
  set connectedDeviceId(int x) => _connectedDeviceId = x;

  @override
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      connectedDeviceId = await readDeviceId(device);
    } catch (e) {
      print('==== Ble connection error : $e ====');
      return;
    }
    final services = await device.discoverServices();
    for (var s in services) {
      for (var c in s.characteristics) {
        if (c.uuid == writeGUID) {
          // Store write characteristic
          writeCharacteristic = c;
        }
        if (c.uuid == notifyGUID) {
          // Store notify characteristic and set up notifications
          notifyCharacteristic = c;
          await c.setNotifyValue(true);
          c.onValueReceived.listen((data) {
            // Handle incoming data
            _incomingContoller.add(Uint8List.fromList(data));
          });
        }
      }
    }
  }

  @override
  Future<void> disconnectToDevice(BluetoothDevice device) async {
    await device.disconnect();
    writeCharacteristic = null;
    notifyCharacteristic = null;
  }

  @override
  Future<void> sendSegment({
    required int type,
    required int sourceId,
    required int destinationId,
    required int uid,
    required int segmentIndex,
    required int totalSegments,
    required Uint8List data,
  }) async {
    if (writeCharacteristic != null) {
      print(
        'type: $type sourceId: $sourceId destinationId: $destinationId uid: $uid segmentIndex: $segmentIndex totalSegments: $totalSegments data: $data',
      );
      final packet = Packet(
        uid: uid,
        type: type,
        sourceId: sourceId,
        destinationId: destinationId,
        segmentIndex: segmentIndex,
        totalSegments: totalSegments,
        payload: data,
      ).toBytes();
      print(packet);
      await writeCharacteristic!.write(packet, withoutResponse: false);
    }
  }

  @override
  Future<void> sendAck({
    required int type,
    required int sourceId,
    required int destinationId,
    required int segmentIndex,
    required int uid,
  }) async {
    if (writeCharacteristic != null) {
      final packet = Packet(
        uid: uid,
        type: type,
        sourceId: sourceId,
        destinationId: destinationId,
        segmentIndex: segmentIndex,
        totalSegments: 0,
        payload: Uint8List(0),
      ).toBytes();
      await writeCharacteristic!.write(packet);
    }
  }

  @override
  Future<int> readDeviceId(BluetoothDevice device) async {
    final deviceId = device.remoteId.toString().replaceAll(':', '');
    return int.parse(deviceId, radix: 16);
  }

  @override
  Future<void> startScan({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    await FlutterBluePlus.startScan(
      timeout: timeout,
      withServices: [serviceGUID],
    );
  }
}
