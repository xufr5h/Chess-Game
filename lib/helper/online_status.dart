import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  try {
    final doc = await _firestore.collection('users').doc(userID).get();
    if (!doc.exists) return false;
    
    final data = doc.data()!;
    final isOnline = data['isOnline'] ?? false;
    final lastOnline = data['lastOnline'] as Timestamp?;
    
    // If explicitly online, return true
    if (isOnline) return true;
    
    // If not explicitly online but was active recently
    if (lastOnline != null) {
      final difference = DateTime.now().difference(lastOnline.toDate());
      return difference.inMinutes < 5; // Increased to 5 minutes
    }
    
    return false;
  } catch (e) {
    debugPrint('Error checking online status: $e');
    return false; // Default to offline if there's an error
  }
}

Stream<bool> getUserOnlineStatusStream(String userID) {
  return _firestore.collection('users').doc(userID)
    .snapshots()
    .map((doc) {
      if (!doc.exists) return false;
      final data = doc.data()!;
      final isOnline = data['isOnline'] ?? false;
      final lastOnline = data['lastOnline'] as Timestamp?;
      
      if (isOnline) return true;
      if (lastOnline != null) {
        return DateTime.now().difference(lastOnline.toDate()).inMinutes < 5;
      }
      return false;
    });
}