import 'package:chess_app/components/pieces.dart';
import 'package:chess_app/components/square.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {

// creating a 2D chess list representing the chess board
 late List<List<chessPiece?>> board;

//  selected piece on the board
chessPiece? selectedPiece;
// setting the default selected piece to null
int selectedRow = -1;
int selectedColumn = -1;


@override
void initState() {
  super.initState();
  _initializeBoard();
}

// Initializing the board
void _initializeBoard() {
List<List<chessPiece?>> newBoard = 
List.generate(8, (index) => List.generate(8, (index) => null));
// placing pawns
for (int i = 0; i < 8; i++) {
  newBoard[1][i] = chessPiece(
    type: chessPieceType.pawn, 
    isWhite: false, 
    imagePath: 'lib/images/pawn.png');

  newBoard[6][i] = chessPiece(
    type: chessPieceType.pawn, 
    isWhite: true, 
    imagePath: 'lib/images/pawn.png');
}

// placing rooks
  newBoard[0][0] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/rook.png');

    newBoard[0][7] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/rook.png');

    newBoard[7][0] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/rook.png');

    newBoard[7][7] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/rook.png');
// placing knights
    newBoard[0][1] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/knight.png');

    newBoard[0][6] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/knight.png');

    newBoard[7][1] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/knight.png');

    newBoard[7][6] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/knight.png');

// placing bishops
    newBoard[0][2] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/bishop.png');

    newBoard[0][5] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/bishop.png');

    newBoard[7][2] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/bishop.png');

    newBoard[7][5] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/bishop.png');
// placing queen
    newBoard[0][3] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/queen.png');

    newBoard[7][3] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/queen.png');
// placing king
    newBoard[0][4] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: false, 
    imagePath: 'lib/images/king.png');

    newBoard[7][4] = chessPiece(
    type: chessPieceType.rook, 
    isWhite: true, 
    imagePath: 'lib/images/king.png');
board = newBoard;

}

// function to handle the selection of a piece
void _selectedPiece(int row, int column){
  setState(() {
    // selecting a piece if there is a piece on the square
    if (board[row][column] != null){
      selectedPiece = board[row][column];
      selectedRow = row;
      selectedColumn = column;
    } else {
      // if there is no piece on the square, deselect the piece
      selectedPiece = null;
      selectedRow = -1;
      selectedColumn = -1;  
    }
  });
}

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
            // checking if the square is selected
            bool isSelected = (selectedRow == y && selectedColumn == x);
            return Square(
              isWhite: isWhite, 
              piece: board[y][x],
              isSelected: isSelected,
              onTap: () => _selectedPiece(y, x),
            );
          },
          itemCount: 8*8,
        ),
    );
  }
}