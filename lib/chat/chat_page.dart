import 'package:chess_app/chat/chat_service.dart';
import 'package:chess_app/components/chat_bubble.dart';
import 'package:chess_app/components/chat_meeting.dart';
import 'package:chess_app/components/textfield.dart';
import 'package:chess_app/helper/app_constants.dart';
import 'package:chess_app/helper/online_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// import 'package:zego_uikit/zego_uikit.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // configuring the zegocall
  // final ZegoUIKitPrebuiltCallConfig config = ZegoUIKitPrebuiltCallConfig(
  //   turnOnCameraWhenJoining: true,
  //   turnOnMicrophoneWhenJoining: true,
  //   useSpeakerWhenJoining: true,
  // );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  });

  }
  

  @override
  void dispose() {
     _messageController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      Future.delayed(
        const Duration(milliseconds: 100),
        _scrollToBottom,
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || currentUser == null) return;

    // clearing the text field
    final message = _messageController.text.trim();
    _messageController.clear();
    setState(() {
      
    });
    
    try {
      await _chatService.sendMessgae(widget.receiverID, message);
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    }
  }

  // // start call method
  // void _startCall(BuildContext context, String receiverID, String receiverEmail, bool isVideoCall){
  //   final resourceID = isVideoCall ? 'zegouikit_video_call' : 'zegouikit_audio_call';
  //   ZegoUIKitPrebuiltCallInvitationService().send(
  //     invitees: [
  //       ZegoCallUser(receiverID, receiverEmail)
  //     ], 
  //     isVideoCall: isVideoCall,
  //     resourceID: resourceID,
  //   ).then((result){
  //     if (!result) {
  //       _showUserOfflineDialog();
  //     }
  //   });
  // }

// offline dialog
  void _showUserOfflineDialog(){
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 35, 44, 49),
          title: const Text(
            'User is offline',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          content: const Text(
            'The user you are trying to call is currently offline.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      );
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      resizeToAvoidBottomInset: false, // Changed to false
      appBar: AppBar(
        centerTitle: true,
        title:
            Text(
              widget.receiverEmail,
              style: const TextStyle(color: Colors.white),
            ),    
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              // _startCall(context, widget.receiverID, widget.receiverEmail, false);
            },
            icon: const Icon(Icons.call, color: Colors.green, size: 28
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: (){
              showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 35, 44, 49),
                context: context,
                builder: (BuildContext context){
                  return  ChatMeeting();
                }
              );
            },
            icon: const Icon(Icons.videocam, color: Colors.green, size: 30),),
        )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: _buildMessageList(),
              ),
            ),
            // Input container with keyboard-aware padding
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: _buildUserInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final senderId = currentUser?.uid;
    if (senderId == null) {
      return const Center(
        child: Text(
          'Please sign in to view messages',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white), );
        }

        final messages = snapshot.data?.docs ?? [];
        if (messages.isEmpty) {
          return const Center(
            child: Text(
              'No messages yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isCurrentUser = data['senderID'] == currentUser?.uid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ChatBubble(
          message: data['message'] ?? '',
          isCurrentUser: isCurrentUser,
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color.fromARGB(255, 31, 28, 28),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              hintText: 'Type a message...',
              obscuretext: false,
              focusNode: _focusNode,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: Colors.green, size: 28),
          ),
        ],
      ),
    );
  }
}