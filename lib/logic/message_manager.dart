// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:test_app/models/drift/app_database.dart';
import 'package:test_app/models/helpers/messagesWithSegments.dart';
import 'package:test_app/models/helpers/packet_model.dart';
import 'package:test_app/services/ble_service.dart';
import 'package:test_app/services/database_service.dart';
import 'package:test_app/utils/converter_tool.dart';
import 'package:uuid/uuid.dart';

class MessageManager extends ChangeNotifier {
  final DatabaseService dbService;
  final BleService bleService;
  final ACK_TYPE = 0;
  final List<_QueuedMessages> _outgoingQueueMessages = [];
  final List<_QueuedSegment> _outgoingQueueSegments = [];

  final List<ReassemblyBuffer> reassemblyBuffers = [];

  MessageManager({required this.dbService, required this.bleService}) {
    _startRetryTimer();
    bleService.incomingMessages.listen((ondata) {
      _handleIncomingMessage(ondata);
    });
  }
  int get deviceId => bleService.connectedDeviceId;
  Future<void> sendMessage({
    required String payload,
    required int senderId,
    required int receiverId,
    required int type,
  }) async {
    final uuid = Uuid().v4obj().toBytes();

    final uid = ConverterTool.uint8ListToInt(uuid.sublist(0, 6));

    final segmentSize = 200;
    final bytes = Uint8List.fromList(payload.codeUnits);
    final totalSegments = (bytes.length / segmentSize).ceil();

    await _insertMessage(
      type,
      senderId,
      receiverId,
      uid,
      totalSegments,
      payload,
    );

    _outgoingQueueMessages.add(
      _QueuedMessages(uid: uid, totalSegments: totalSegments),
    );

    await generateSegments(
      type,
      senderId,
      receiverId,
      uid,
      segmentSize,
      totalSegments,
      bytes,
    );

    _sendNextSegment();
  }

  Future<void> generateSegments(
    int type,
    int senderId,
    int receiverId,
    int uid,
    int segmentSize,
    int totalSegments,
    Uint8List bytes,
  ) async {
    for (var i = 0; i < bytes.length; i += segmentSize) {
      final segmentIndex = i ~/ segmentSize;
      final end = (i + segmentSize < bytes.length)
          ? i + segmentSize
          : bytes.length;
      final payload = bytes.sublist(i, end);

      await _insertSegment(uid, segmentIndex, payload, false);

      _outgoingQueueSegments.add(
        _QueuedSegment(
          uid: uid,
          segmentIndex: segmentIndex,
          data: payload,
          type: type,
          sourceId: senderId,
          destinationId: receiverId,
          totalSegments: totalSegments,
        ),
      );
    }
  }

  Future<int> _insertMessage(
    int type,
    int senderId,
    int receiverId,
    int uid,
    int totalSegments,
    String payload,
  ) async {
    final msgId = await dbService.insertMessage(
      MessagesCompanion.insert(
        uid: uid,
        sourceId: senderId,
        destinationId: receiverId,
        type: type,
        status: 'pending',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        totalSegments: Value(totalSegments),
        payload: Value(payload),
      ),
    );

    return msgId;
  }

  Future<int> _insertSegment(
    int uid,
    int segmentIndex,
    Uint8List payload,
    bool ackReceived,
  ) async {
    final segId = await dbService.insertSegment(
      SegmentsCompanion.insert(
        uid: uid,
        segmentIndex: segmentIndex,
        ackReceived: Value(ackReceived),
        payload: payload,
      ),
    );

    return segId;
  }

  void _sendNextSegment() {
    if (_outgoingQueueSegments.isEmpty) return;
    final segment = _outgoingQueueSegments.take(5).toList();
    for (var i in segment) {
      bleService.sendSegment(
        type: i.type,
        sourceId: i.sourceId,
        destinationId: i.destinationId,
        uid: i.uid,
        segmentIndex: i.segmentIndex,
        totalSegments: i.totalSegments,
        data: i.data,
      );
    }
  }

  void _startRetryTimer() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (_outgoingQueueSegments.isEmpty) {
        return;
      }

      final queue = _outgoingQueueSegments.take(5).toList();
      final toRetry = <_QueuedSegment>[];

      for (final s in queue) {
        final segmentRecord = await dbService.getSegment(s.uid, s.segmentIndex);

        if (!segmentRecord.ackReceived && segmentRecord.retryCount < 3) {
          toRetry.add(s);
          await dbService.incrementSegmentRetry(segmentRecord);
        }
      }

      for (final s in toRetry) {
        bleService.sendSegment(
          type: s.type,
          sourceId: s.sourceId,
          destinationId: s.destinationId,
          uid: s.uid,
          segmentIndex: s.segmentIndex,
          totalSegments: s.totalSegments,
          data: s.data,
        );
      }
    });
  }

  void _handleIncomingMessage(Uint8List ondata) async {
    final packet = Packet.fromBytes(ondata);
    if (packet == null) return;

    if (packet.type == ACK_TYPE ) {
      _handleAck(packet);
    }

    if (packet.type != ACK_TYPE ) {
      _handleData(packet);
    }
  }

  void _handleAck(Packet packet) async {
    final segment = await dbService.getSegment(packet.uid, packet.segmentIndex);
    final segmentId = segment.id;
    await dbService.markSegmentAck(segmentId);

    _outgoingQueueSegments.removeWhere(
      (s) => s.uid == packet.uid && s.segmentIndex == packet.segmentIndex,
    );

    if (_outgoingQueueSegments.isEmpty) {
      _outgoingQueueMessages.removeWhere((m) => m.uid == packet.uid);
    }
    _sendNextSegment();
  }
  Stream<List<MessageWithSegments>> watchMessages() => dbService.watchMessages();
  void _handleData(Packet packet) async {
    BufferSegment segment = BufferSegment(
      segmentIndex: packet.segmentIndex,
      payload: packet.payload,
    );
    ReassemblyBuffer? buffer;
    try {
      buffer = reassemblyBuffers.firstWhere(
        (b) => b.uid == packet.uid && b.sourceId == packet.sourceId,
      );
    } catch (e) {
      buffer = ReassemblyBuffer(
        uid: packet.uid,
        sourceId: packet.sourceId,
        destinationId: packet.destinationId,
        totalSegments: packet.totalSegments,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      reassemblyBuffers.add(buffer);
    }
    final segmentExists = buffer.segments.any(
      (s) => s.segmentIndex == packet.segmentIndex,
    );

    if (!segmentExists) {
      buffer.segments.add(segment);
    }
    //send ack
    bleService.sendAck(
      type: ACK_TYPE,
      sourceId: bleService.connectedDeviceId,
      destinationId: packet.sourceId,
      segmentIndex: packet.segmentIndex,
      uid: packet.uid,
    );

    if (buffer.segments.length == buffer.totalSegments) {
      buffer.segments.sort((a, b) => a.segmentIndex.compareTo(b.segmentIndex));
      final payload = _joinSegmentsAsString(buffer.segments);
      await _insertMessage(
        packet.type,
        packet.sourceId,
        packet.destinationId,
        packet.uid,
        buffer.totalSegments,
        payload,
      );
      reassemblyBuffers.removeWhere((m) => m.uid == packet.uid);
    }
  }

  String _joinSegmentsAsString(List<BufferSegment> segments) {
    final builder = BytesBuilder();
    for (final s in segments) {
      builder.add(s.payload);
    }
    // convert bytes to UTF-8 string
    return utf8.decode(builder.toBytes());
  }
}

class _QueuedSegment {
  final int type;
  final int sourceId;
  final int destinationId;
  final int uid;
  final int segmentIndex;
  final int totalSegments;
  final Uint8List data;
  _QueuedSegment({
    required this.type,
    required this.sourceId,
    required this.destinationId,
    required this.uid,
    required this.segmentIndex,
    required this.totalSegments,
    required this.data,
  });
}

class _QueuedMessages {
  final int uid;
  final int totalSegments;
  _QueuedMessages({required this.uid, required this.totalSegments});
}

class ReassemblyBuffer {
  final int uid;
  final int sourceId;
  final int destinationId;
  final int totalSegments;
  final int timestamp;
  List<BufferSegment> segments = [];
  ReassemblyBuffer({
    required this.uid,
    required this.sourceId,
    required this.destinationId,
    required this.totalSegments,
    required this.timestamp,
  });
}

class BufferSegment {
  final int segmentIndex;
  final Uint8List payload;

  BufferSegment({required this.segmentIndex, required this.payload});
}
