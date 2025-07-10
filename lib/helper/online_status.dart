import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;


// setting the onlne status of the user
Future<bool> setUserOnlineStatus(bool isOnline) async {
  final user = _auth.currentUser;
  if (user == null) {
    return false; // User is not authenticated
  }
  await _firestore.collection('users').doc(user.uid).update({
    'isOnline': isOnline,
    'lastOnline': isOnline ? FieldValue.serverTimestamp() : null,
  });
  return true;
}

// checking the online status of the user
Future<bool> isUserOnline(String userID) async {
  final doc = await _firestore.collection('users').doc(userID).get();
  if (!doc.exists) {
    return false; // User document does not exist
  }
  final data = doc.data();
  return data?['isOnline'] ?? false;
}