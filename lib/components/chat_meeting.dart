import 'package:chess_app/chat/chat_service.dart';
import 'package:chess_app/chat/schedule.dart';
import 'package:chess_app/helper/meeting_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatMeeting extends StatelessWidget {
  final String receiverId;
  final String currentId;

   ChatMeeting({super.key, required this.receiverId, required this.currentId});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;


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
            onTap: () async {
              final roomName = 'InstantMeeting${DateTime.now().millisecondsSinceEpoch}';
              final meetingUrl = 'https://meet.jit.si/$roomName';

              // Send the link in chat
              await ChatService().sendMessageToChat(
                currentUser?.uid ?? '',
                receiverId,
                'Instant Meeting: $meetingUrl',
              );

              // Save the meeting in Firestore
              await storeMeeting(
                currentUser?.uid ?? '',
                receiverId,
                DateTime.now(), // Current time for instant
              );

              Navigator.pop(context); // close the sheet

              await joinInstantMeeting(roomName);

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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Schedule(
                  currentId: currentId,
                  receiverId: currentId,
                  )),
              );
            },
            leading: const Icon(Icons.calendar_month, color: Colors.white,),
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