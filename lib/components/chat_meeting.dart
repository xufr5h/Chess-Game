import 'package:chess_app/helper/meeting_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatMeeting extends StatelessWidget {

   ChatMeeting({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


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
              Navigator.pop(context);
              await joinInstantMeeting( 'InstantMeeting${DateTime.now().millisecondsSinceEpoch}');

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