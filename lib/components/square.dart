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
    double borderWidth = 1;
    if (isSelected) {
      squareColor = const Color.fromARGB(255, 175, 235, 11).withAlpha(150);
    } 
    else {
      squareColor = isWhite ? const Color.fromARGB(255, 245, 245, 220).withAlpha(180) : const Color.fromARGB(255, 72, 161, 58).withAlpha(150);
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
        child: Stack(
          children: [ 
            Container(
            child: piece != null ? Image.asset(
              piece!.imagePath, 
              color: piece!.isWhite? Colors.white : Colors.black) : null,
          ),
          if (isValidMove && piece == null)
            Center(
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.lightGreenAccent.withAlpha(150),
                  shape: BoxShape.circle,
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}