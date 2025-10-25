import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            child: IconButton(onPressed: () {}, icon: Icon(Icons.person)),
          ),
          title: Text('User $index'),
          subtitle: Text('Message $index', style: TextStyle(color: Colors.grey),),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('10:00 AM',style: TextStyle(color: Colors.grey, fontSize: 13),),
          ]),
          onTap: () {
            Navigator.pushNamed(context, '/main/messaging',arguments: 
            
            {
              'title': "User $index",
            }
            
            );
          },
        );
      },
    );
  }
}
