// lib/model/packet.dart

import 'dart:typed_data';

import 'package:test_app/utils/converter_tool.dart';

/// Packet types

/// Wire layout (bytes):
/// [0]            : type (1)
/// [1..6]         : sourceId (6)  (uint8)
/// [7..12]         : destinationId (6) (uint8)
/// [13..18]        : uid (6) (uint8)  -- short id/hash of UUID
/// [19]           : segmentIndex (1)
/// [20]           : totalSegments (1)
/// [21]           : payloadLength (1)
/// [22..]         : payload bytes (payloadLength)
///
/// This gives 22 bytes header (fixed) + payload.

class Packet {
  final int type;
  final int sourceId;
  final int destinationId;
  final int uid;
  final int segmentIndex;
  final int totalSegments;
  final Uint8List payload;

  Packet({
    required this.type,
    required this.sourceId,
    required this.destinationId,
    required this.uid,
    required this.segmentIndex,
    required this.totalSegments,
    required this.payload,
  });

  /// Serialize to bytes
  Uint8List toBytes() {
    final bytes = BytesBuilder();
    final payloadLength = payload.length;
    bytes.add([type]);
    bytes.add(ConverterTool.intToUint8List(sourceId, 6));
    bytes.add(ConverterTool.intToUint8List(destinationId, 6));
    bytes.add(ConverterTool.intToUint8List(uid, 6));
    bytes.add([segmentIndex, totalSegments, payloadLength]);
    bytes.add(payload);
    return bytes.toBytes();
  }

  /// Parse bytes into Packet. Returns null if format invalid.
  static Packet? fromBytes(Uint8List data) {
    if (data.length < 22) return null;

    int offset = 0;
    final type = data[offset];
    offset += 1;
    final sourceId = ConverterTool.uint8ListToInt(
      data.sublist(offset, offset + 6),
    );
    offset += 6;
    final destinationId = ConverterTool.uint8ListToInt(
      data.sublist(offset, offset + 6),
    );
    offset += 6;
    final uid = ConverterTool.uint8ListToInt(data.sublist(offset, offset + 6));
    offset += 6;
    final segmentIndex = data[offset];
    offset += 1;
    final totalSegments = data[offset];
    offset += 1;
    final payloadLength = data[offset];
    offset += 1;
    if (data.length < offset + payloadLength) return null;
    final payload = data.sublist(offset, offset + payloadLength);
    return Packet(
      type: type,
      sourceId: sourceId,
      destinationId: destinationId,
      uid: uid,
      segmentIndex: segmentIndex,
      totalSegments: totalSegments,
      payload: Uint8List.fromList(payload),
    );
  }
}
