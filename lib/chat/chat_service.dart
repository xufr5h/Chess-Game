import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {

  // get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // get messages
}
