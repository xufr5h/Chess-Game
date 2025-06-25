import 'package:chess_app/components/pieces.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {

  final bool isWhite;
  final chessPiece ? piece;
  const Square({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? const Color.fromARGB(255, 161, 151, 151) : const Color.fromARGB(255, 89, 38, 20),
      child: piece != null ? Image.asset(piece!.imagePath, color: piece!.isWhite? Colors.white : Colors.black) : null,
    );
  }
}