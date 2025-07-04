import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;

  const ChatPage({super.key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: Text(receiverEmail, style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
    );
  }
}