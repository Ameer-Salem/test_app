import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:test_app/controllers/database_controller.dart';
import 'package:test_app/controllers/messaging_controller.dart';
import 'package:test_app/widgets/messagebubble_widget.dart';
import 'package:test_app/widgets/voice_recording_widget.dart';

class MessagingScreen extends StatelessWidget {
  MessagingScreen({super.key});

  late bool sender = true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessagingController>(context);
    final service = Provider.of<DatabaseController>(
      context,
      listen: false,
    ).service;
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
        actions: [
          Switch(
            value: sender,
            onChanged: (value) {
              sender = value;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: service.getMessagesWithAttachments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    controller: provider.scrollController,
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, i) {
                      final index = messages.length - 1 - i;
                      final msg = messages[index].message;
                      final time = DateFormat(
                        "hh:mm a",
                      ).format(msg.timeStamp).toString();

                      return MessageBubble(
                        type: msg.type,
                        isMe: msg.senderId == 1 ? true : false,
                        text: msg.type == "text" ? msg.textContent : null,
                        time: time,
                        duration: Duration(seconds: 10),
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
                            service.addMessage(
                              senderId: sender ? 1 : 2,
                              receiverId: sender ? 2 : 1,
                              content: "Voice Message",
                              type: "voice",
                            );
                            provider.notify();
                            provider.scrollToBottom();
                          },
                        )
                      : IconButton(
                          onPressed: () {
                            if (provider.controller.text.trim().isEmpty) {
                              return;
                            }
                            service.addMessage(
                              senderId: sender ? 1 : 2,
                              receiverId: sender ? 2 : 1,
                              content: provider.controller.text,
                              type: "text",
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
