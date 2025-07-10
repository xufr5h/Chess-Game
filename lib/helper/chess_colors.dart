import 'package:flutter/material.dart';

class ChessColors {
  final String name;
  final Color lightSquareColor;
  final Color darkSquareColor;
  final Color selectedSquareColor;
  final Color validMoveColor;
  final Color checkBorderColor;

ChessColors({
  required this.name,
  required this.lightSquareColor,
  required this.darkSquareColor,
  required this.selectedSquareColor,
  required this.validMoveColor,
  required this.checkBorderColor,
});
}

final List<ChessColors> availableThemes = [
  ChessColors(
    name: 'Classic', 
    lightSquareColor: Color(0xFFF5F5DC).withAlpha(180),
    darkSquareColor: Color(0xFF48A13A).withAlpha(150), 
    selectedSquareColor: Color(0xFFAFEB0B).withAlpha(150), 
    validMoveColor:  Colors.lightGreenAccent.withAlpha(150),
    checkBorderColor: Colors.red,
  ),
  ChessColors(
    name: 'Pink', 
    lightSquareColor: Color(0xFFF5F5DC).withAlpha(180),
    darkSquareColor:const Color.fromARGB(255, 217, 132, 160).withAlpha(150), 
    selectedSquareColor:  Color(0xFFA0D5FF).withAlpha(150),
    validMoveColor: Colors.blueAccent.withAlpha(150),
    checkBorderColor: Colors.orange,
  ),
  ChessColors(
    name: 'Wood',
    lightSquareColor: Color(0xFFEED9B7).withAlpha(180),
    darkSquareColor: Color(0xFF8B5A2B).withAlpha(150),
    selectedSquareColor: Color(0xFFFFD700).withAlpha(150),
    validMoveColor: Colors.green.withAlpha(150),
    checkBorderColor: Colors.redAccent,
  ),
];