import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScore extends ChangeNotifier{
  int _gamesPlayed = 0;
  int _gamesWon = 0;
  int _gamesLost = 0;
  int _gamesDrawn = 0;
  int _rating = 1200;

  int get gamesPlayed => _gamesPlayed;
  int get gamesWon => _gamesWon;
  int get gamesLost => _gamesLost;
  int get gamesDrawn => _gamesDrawn;
  int get rating => _rating;
  
  // standard chess calculations
  double get score => _gamesWon + (_gamesDrawn * 0.5);

  // calculating the win rate
  double get winRate => _gamesPlayed > 0
      ? (_gamesWon / _gamesPlayed) * 100
      : 0.0;
  
  // recording results
  void recordResult({
    required bool isWin,
    required bool isDraw,
  }){
    // inputting validation
    assert(!(isWin && isDraw), 
      'A game cannot be both a win and a draw.');
    _gamesPlayed++;

    if (isWin) {
      _gamesWon++;
    } else if (isDraw){
      _gamesDrawn++;
    } else {
      _gamesLost++;
    }
    notifyListeners();
  }
  // reset all scores
  void resetScores(){
    _gamesPlayed = 0;
    _gamesWon = 0;
    _gamesLost = 0;
    _gamesDrawn = 0;
    notifyListeners();
  }

  // adding the method to update scores
  Future<void> loadUserStatsFirestore(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final data = userDoc.data();
      _gamesPlayed = data?['gamesPlayed'] ?? 0;
      _gamesWon = data?['gamesWon'] ?? 0;
      _gamesLost = data?['gamesLost'] ?? 0;
      _gamesDrawn = data?['gamesDrawn'] ?? 0;
      _rating = data?['rating'] ?? 1200;
      notifyListeners();
    }
  }
}