import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final void Function()? onSend; // callback when user finishes recording

  const VoiceRecorderWidget({super.key, this.onSend});

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with SingleTickerProviderStateMixin {
  bool isRecording = false;
  Duration recordDuration = Duration.zero;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (isRecording) {
        setState(() {
          recordDuration = elapsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
      recordDuration = Duration.zero;
    });
    _ticker.start();
  }

  void _stopRecording() {
    _ticker.stop();
    setState(() {
      isRecording = false;
    });
    widget.onSend?.call(); // notify parent
  }

  void _cancelRecording() {
    _ticker.stop();
    setState(() {
      isRecording = false;
      recordDuration = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isRecording) {
      return IconButton(
        onPressed: _startRecording,
        icon: Icon(Icons.mic_rounded),
      );
    }

    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: _cancelRecording,
        ),
        Text(
          "${recordDuration.inMinutes}:${(recordDuration.inSeconds % 60).toString().padLeft(2, '0')}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.send_rounded, color: Colors.blue),
          onPressed: _stopRecording,
        ),
      ],
    );
  }
}
