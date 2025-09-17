import 'package:flutter/cupertino.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:test_app/models/app_database.dart';
import 'package:test_app/services/message_service.dart';
import 'package:test_app/widgets/messagebubble_widget.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {

  late final MessageService service;
  bool sender = true;
  
  @override
  void initState() {
    super.initState();
    final db = AppDatabase();
    service = MessageService(db);
    
  }
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          CupertinoSwitch(
            value: sender,
            onChanged: (value) {
              setState(() {
                sender = value;
              });
            },
          ),
          Text(sender ? 'Sender' : 'Receiver'),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageWithAttachments>>(
              stream: service.watchMessagesWithAttachments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      text: message.message.textContent ?? '',
                      time: message.message.timeStamp.toString(),
                      isMe: message.message.senderId == 1,
                    );
                  },
                );
              },
            ),
          ),

          // text field and plus & send buttons row
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
                    controller: messageController,
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
                  child: IconButton(
                    onPressed: () async{
                      if (messageController.text.isEmpty) return;
                      await service.addMessage(senderId: sender ? 1 : 2, receiverId: sender ? 2 : 1,type: "text", text: messageController.text, isSent: sender);
                      messageController.clear();
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
