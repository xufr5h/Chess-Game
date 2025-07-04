import 'package:chess_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get _currentUser => _auth.currentUser;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUserStream(){
    try {
      return _firestore.collection('users')
      .where('email', isNotEqualTo: FirebaseAuth.instance.currentUser?.email)
      .snapshots()
      .handleError((error){
        print('Firestore error: $error');
        throw error;
      })
      .map((snapshot) => snapshot.docs
        .map((doc) => doc.data())
        .where((user) => user['email'] != null)
        .toList());
    } catch (e) {
      print('Error getting user stream: $e');
      rethrow;
    }
  }

  // send message
   // send message method
  Future <void> sendMessgae(String receiverID, message) async {
    // get currend user d
    try {
      if (_currentUser == null) {
        throw Exception('User not authenticated');
      }
      final Timestamp timestamp = Timestamp.now();

      // creating message data
      Message newMessage = Message(
        senderID: _currentUser!.uid, 
        receiverEmail: _currentUser!.email ?? '', 
        receiverID: receiverID, 
        message: message, 
        timestamp: timestamp);

      // constructing the chat room id 
      List<String> ids = [_currentUser!.uid, receiverID];
      ids.sort();
      String ChatRoomID = ids.join('_'); 

      // adding message to firestore
      await _firestore.collection('chatRooms').doc(ChatRoomID).collection('messages').add(newMessage.toMap());  

      // updating the chat room with the latest message
       await _firestore.collection('chatRooms')
          .doc(ChatRoomID)
          .set({
            'participants': [_currentUser!.uid, receiverID],
            'lastMessage': message,
            'lastMessageTime': timestamp,
          }, SetOptions(merge: true));

    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  // get messages method
  Stream <QuerySnapshot> getMessages(String userID, otherUserID){
    // constructing the chat room id for both users
    List<String> ids = [userID, otherUserID];
    ids.sort(); 
    String ChatRoomID = ids.join('_');

    return _firestore
      .collection('chatRooms')
      .doc(ChatRoomID)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .handleError((error) {
        print('Firestore error: $error');
        throw error;
      });
  }
  
}
