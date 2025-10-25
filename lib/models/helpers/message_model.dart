class SimpleMessage {
  final int senderId;
  final int receiverId;
  final String text;
  final int timestamp;
  final bool isSent;

  SimpleMessage({required this.senderId, required this.receiverId,
    required this.text, required this.timestamp, required this.isSent});

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'textcontent': text,
    'timeStamp': timestamp,
    'isent': isSent ? 1 : 0,
  };
}