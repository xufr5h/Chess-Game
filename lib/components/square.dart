import 'package:chess_app/components/pieces.dart';
import 'package:chess_app/helper/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

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
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    Color? squareColor;
    Color? borderColor;
    double borderWidth = 1;
    if (isSelected) {
      squareColor = theme.selectedSquareColor;
    } 
    else {
      squareColor = isWhite ? theme.lightSquareColor : theme.darkSquareColor;
    }
    // add red border if the king is in check
    if (isInCheck && piece?.type == chessPieceType.king) {
      borderColor = theme.checkBorderColor;
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
                  color: theme.validMoveColor,
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