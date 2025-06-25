import 'package:chess_app/components/pieces.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {

  final bool isWhite;
  final chessPiece ? piece;
  const Square({super.key, required this.isWhite, required this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? Colors.white : Colors.brown,
      child: piece != null ? Image.asset(piece!.imagePath) : null,
    );
  }
}