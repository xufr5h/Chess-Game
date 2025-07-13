import 'package:flutter/material.dart';

class ChatMeeting extends StatelessWidget {
  const ChatMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      body: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.pop(context);
            },
            leading: const Icon(Icons.close, color: Colors.white,),
            title: const Text(
              'Create Video Meeting Link',
             style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
             ),
             ),
          const Divider(),
          ListTile(
            onTap: (){
              
            },
            leading: const Icon(Icons.bolt, color: Colors.white,),
            title: const Text(
              'Send Instant Meeting Link',
             style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
             ),
             ),
          ListTile(
            onTap: (){
             
            },
            leading: const Icon(Icons.schedule, color: Colors.white,),
            title: const Text(
              'Send Scheduled Meeting Link',
             style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
             ),
             ),
        ],
      ),
    );
  }
}