import 'dart:ffi';
import 'dart:typed_data';

class Packet {
  final int type; // 0 for text, 1 for attachment
  final int source; // 0 for device, 1 for user
  final int destination; // 0 for device, 1 for user
  final int sequence;
  final int length;
  final List<int> payload;

  Packet({
    required this.type,
    required this.source,
    required this.destination,
    required this.sequence,
    required this.payload,
  }) : length = payload.length;

  Uint8List toBytes() {
    final bytes = BytesBuilder();
    bytes.add([type,source,destination,sequence,length]);
    bytes.add(payload);
    return bytes.toBytes();
  }
  factory Packet.fromBytes(List<int> bytes) {
    if (bytes.length < 5) {
      throw Exception("Invalid packet length");
    }
    return Packet(
      type: bytes[0],
      source: bytes[1],
      destination: bytes[2],
      sequence: bytes[3],
      payload: bytes.sublist(5)
    );
  }
  
}

