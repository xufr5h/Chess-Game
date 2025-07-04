import 'package:chess_app/chat/chat_service.dart';
import 'package:chess_app/components/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

   ChatPage({super.key, required this.receiverEmail, required this.receiverID});
   final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get _currentUser => _auth.currentUser;

  // text controller 
  final TextEditingController _messageController = TextEditingController();

  // chat service
  final ChatService _chatService = ChatService();

  // send message method 
  void sendMessage() async {
    // sending message if the textfield is not empty
    if (_messageController.text.isNotEmpty) {
      // sending message
    await _chatService.sendMessgae(receiverID, _messageController.text);

    // clearing the textfield
    _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        title: Text(receiverEmail, style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
      body: Column(
        children: [
          // displaying the chat messages 
          Expanded(
            child: _buildMessageList(),
          ),
          
          // displaying users input 
          _buildUserInput(),
        ],
      ),
    );
  }

  // building the message list
  Widget _buildMessageList(){
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID), 
      builder: (context, snapshot){
        // error handling
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', 
              style: const TextStyle(color: Colors.white)),
          );
        }
        // loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
          
        }

        // displaying the messages
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageListItem(doc)).toList(),
        );
      }
    );
  }

  // building individual message item
  Widget _buildMessageListItem(DocumentSnapshot doc){
    Map <String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['message']);
  }

  // building the inout field 
  Widget _buildUserInput(){
    return Row(
      children: [
        // textfield for user input
        Expanded(
          child: MyTextfield(
            controller: _messageController, 
            hintText: 'Enter your message', 
            obscuretext: false
            ),
          ),

        // send button
        IconButton(
          onPressed: sendMessage, 
          icon: Icon(
            Icons.send,
            color: Colors.white,
          )
        ),
      ],
    );
  }
}