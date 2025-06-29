import 'package:chess_app/components/pieces.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {

  final bool isWhite;
  final chessPiece ? piece;
  final bool isSelected;
  final bool isValidMove;
  final bool isInCheck;
  final void Function()? onTap;

  const Square({
    super.key, 
    required this.isWhite, 
    required this.piece,
    required this.isSelected,
    required this.isValidMove,
    required this.isInCheck,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    Color? borderColor;
    double borderWidth = 0.0;
    if (isSelected) {
      squareColor = Colors.green;
    } else if(isValidMove){
      squareColor = const Color.fromARGB(255, 125, 242, 129);
    }
    else {
      squareColor = isWhite ? const Color.fromARGB(255, 161, 151, 151) : const Color.fromARGB(255, 89, 38, 20);
    }

    // add red border if the king is in check
    if (isInCheck && piece?.type == chessPieceType.king) {
      borderColor = Colors.red;
      borderWidth = 2.0;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth,
        ),
        ),
        child: piece != null ? Image.asset(
          piece!.imagePath, 
          color: piece!.isWhite? Colors.white : Colors.black) : null,
      ),
    );
  }
}