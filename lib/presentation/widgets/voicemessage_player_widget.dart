import 'package:flutter/material.dart';

class VoiceMessagePlayer extends StatefulWidget {
  final Duration duration;
  final bool isMe;
  const VoiceMessagePlayer({
    super.key,
    required this.duration,
    required this.isMe,
  });
  @override
  State<VoiceMessagePlayer> createState() => _VoicemessagePlayerWidgetState();
}

class _VoicemessagePlayerWidgetState extends State<VoiceMessagePlayer> {
  bool isPlaying = false;
  Duration position = Duration.zero;

  void togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
    });

    // TODO: Implement actual audio playback logic here
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.duration.inMilliseconds == 0
        ? 0
        : position.inMilliseconds / widget.duration.inMilliseconds;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: widget.isMe
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onInverseSurface,
          ),
          onPressed: togglePlayPause,
        ),
        Expanded(
          child: Slider(
            thumbColor: widget.isMe
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary,
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              setState(() {
                position = Duration(
                  milliseconds: (value * widget.duration.inMilliseconds)
                      .toInt(),
                );
                // TODO: Update actual audio playback position here
              });
            },
          ),
        ),
        Text(
          "${position.inSeconds}s / ${widget.duration.inSeconds}s",
          style: TextStyle(
            fontSize: 12,
            color: widget.isMe
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
      ],
    );
  }
}
