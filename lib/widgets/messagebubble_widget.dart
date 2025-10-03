import 'package:flutter/material.dart';
import 'package:test_app/widgets/voicemessage_player_widget.dart';

class MessageBubble extends StatelessWidget {
  final String? text;
  final bool isMe;
  final String time;
  final String type;
  final Duration? duration;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.time,
    required this.type,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isMe
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.inverseSurface;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            constraints: BoxConstraints(
              minWidth: MediaQuery.sizeOf(context).width * 0.2,
              maxWidth: MediaQuery.sizeOf(context).width * 0.75,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: type == "text"
                ? Text(
                    text ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      color: isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onInverseSurface,
                    ),
                  )
                : VoiceMessagePlayer(
                    duration: duration ?? Duration.zero,
                    isMe: isMe,
                  ),
          ),
          SizedBox(height: 4),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
