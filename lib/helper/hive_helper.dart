import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chess_app/helper/offline_game_record.dart';

Future<Box<OfflineGameRecord>> openUserHistoryBox() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw Exception("User is not authenticated");
  } else {
    return await Hive.openBox<OfflineGameRecord>(
      'humanGameRecords_${user.uid}',
    );
  }
}

Future<void> syncGameToFirestore(OfflineGameRecord game) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
    }
    try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('gameHistory')
        .doc(game.gameId)
        .set({
          'gameId': game.gameId, 
          'player1': game.player1,
          'player2': game.player2,
          'result': game.result,
          'playedAt' : game.playedAt,
          'syncedAt': FieldValue.serverTimestamp(),
        });
        debugPrint("Game synced to Firestore: ${game.player1} vs ${game.player2}");
    } catch (e) {
      debugPrint("Error syncing game to Firestore: $e");
    }
}

Future<void> loadGamesFromFirestore() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return;
  }
  try {
    final box = await openUserHistoryBox();
    final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('gameHistory')
      .get();
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final game = OfflineGameRecord(
        gameId: data['gameId'] ?? doc.id, // Use doc ID if gameId is not present
        player1: data['player1'],
        player2: data['player2'],
        result: data['result'],
        playedAt: (data['playedAt'] as Timestamp).toDate(),
      );
    // avoiding duplication 
    bool exists = box.values.any((g) =>
    g.gameId == game.gameId 
    );
    if (!exists) {
      await box.add(game);
    }
    }
    debugPrint("Games loaded from Firestore");
  } catch (e) {
    debugPrint("Error loading games from Firestore: $e");
  }
}