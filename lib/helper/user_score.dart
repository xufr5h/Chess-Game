import 'package:flutter/material.dart';

class UserScore extends ChangeNotifier{
  int _gamesPlayed = 0;
  int _gamesWon = 0;
  int _gamesLost = 0;
  int _gamesDrawn = 0;

  int get gamesPlayed => _gamesPlayed;
  int get gamesWon => _gamesWon;
  int get gamesLost => _gamesLost;
  int get gamesDrawn => _gamesDrawn;
  
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
}