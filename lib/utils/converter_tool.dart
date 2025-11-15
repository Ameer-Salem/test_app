import 'dart:typed_data';

class ConverterTool {
  static int uint8ListToInt(Uint8List bytes) {
    final byteData = ByteData.sublistView(bytes);
    return byteData.getUint64(0, Endian.big);
  }

  static Uint8List intToUint8List(int value, int length) {
    final ByteData byteData = ByteData(8);
    byteData.setInt64(0, value, Endian.big);
    return byteData.buffer.asUint8List(0, length);
  }
}
