import 'dart:typed_data';

class ConverterTool {
  static int uint8ListToInt(Uint8List bytes) {
    int value = 0;
    for (var b in bytes) {
      value = (value << 8) | b;
    }
    return value;
  }

  static Uint8List intToUint8List(int value, int length) {
    
    final byteData = ByteData(8);
    byteData.setInt64(0, value, Endian.big);
    return byteData.buffer.asUint8List(2, length);
  }
}
