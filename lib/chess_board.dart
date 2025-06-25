import 'package:chess_app/components/pieces.dart';
import 'package:chess_app/components/square.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  chessPiece myPawn = chessPiece(
    type: chessPieceType.pawn, 
    isWhite: true, 
    imagePath: 'lib/images/pawn.png'
  );
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 200, 200),
      body: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,),
          itemBuilder: (context, index) {
            int x = index % 8; //this is for the column
            int y = index ~/ 8; // this is for the row
      
            bool isWhite = (x + y) % 2 == 0; // Checking if the square is white or brown
            return Square(isWhite: isWhite, piece: myPawn,);
          },
          itemCount: 8*8,
        ),
    );
  }
}