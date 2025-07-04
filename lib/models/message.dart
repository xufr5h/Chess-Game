import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.receiverEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  // converting to a map
  Map<String, dynamic> toMap(){
    return {
      'senderID': senderID,
      'receiverEmail': receiverEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}