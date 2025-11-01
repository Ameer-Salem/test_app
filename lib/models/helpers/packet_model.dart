import 'dart:typed_data';

class Packet {
  final int type; 
  final int source; 
  final int destination; 
  final int sequence;
  final int length;
  final List<int> payload;

  Packet({
    required this.type,
    required this.source,
    required this.destination,
    required this.sequence,
    required this.length,
    required this.payload,
  });

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
      length: bytes[4],
      payload: bytes.sublist(5)
    );
  }
  
}

