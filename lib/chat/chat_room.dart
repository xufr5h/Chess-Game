import 'package:chess_app/chat/chat_page.dart';
import 'package:chess_app/chat/chat_service.dart';
import 'package:chess_app/components/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
   ChatRoom({super.key});

  //  chat services
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chat Room',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
      body: _buildUserList(),
    );
  }

  // Buikding the list of user except for the current user
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUserStream(), 
      builder: (context, snapshot){
        // has error
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', 
              style: const TextStyle(color: Colors.white)),
          );
        }
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // return list of users
        return ListView(
          children: snapshot.data!
          .map<Widget>((user) => _buildUserListItem(user, context)).toList(),
        );
      }
    );
  }

  // building individual list item
  Widget _buildUserListItem(Map<String, dynamic> user, BuildContext context){
    // displaying all the users except current user
    return UserTile(
      text: user['email'],
      onTap: 
        // tapped on a user -> go to chat screen
        () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ChatPage(
            receiverEmail: user['email'],
            receiverID: user['uid'],
          ),
        ),
        ),
      );
  }
}