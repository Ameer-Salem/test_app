import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/logic/message_manager.dart';
import 'package:test_app/logic/messaging_controller.dart';
import 'package:test_app/presentation/widgets/message_bubble_widget.dart';
import 'package:test_app/presentation/widgets/voice_recording_widget.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  @override
  Widget build(BuildContext context) {
    final messageManager = Provider.of<MessageManager>(context, listen: false);
    final provider = Provider.of<MessagingController>(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
        title: Text(args['title']),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: messageManager.watchMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    controller: provider.scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, i) {
                      final index = messages.length - 1 - i;
                      final msg = messages[index].message;
                      return MessageBubble(
                        message: msg,
                        connectedDeviceId: messageManager.deviceId,
                      );
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add_rounded),
                  ),
                ),
                Expanded(
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    onChanged: (value) {
                      provider.notify();
                    },
                    controller: provider.controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      label: Text('Type message'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: provider.controller.text.isEmpty
                      ? VoiceRecorderWidget(
                          onSend: () {
                            //TODO send voice message
                          },
                        )
                      : IconButton(
                          onPressed: () {
                            final payload = provider.controller.text.trim();
                            if (provider.controller.text.trim().isEmpty) {
                              return;
                            }
                            messageManager.sendMessage(
                              payload: payload,
                              senderId: messageManager.deviceId,
                              receiverId: 0,
                              type: 1,
                            );
                            provider.controller.clear();
                            provider.scrollToBottom();
                          },
                          icon: Icon(Icons.send_rounded),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
