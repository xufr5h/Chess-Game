import 'package:chess_app/components/pieces.dart';
import 'package:chess_app/components/square.dart';
import 'package:chess_app/helper/helper_method.dart';
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

// creating a list of valid moves for the selected piece
List<List<int>> validMoves = [];

@override
void initState() {
  super.initState();
  _initializeBoard();
}

// Initializing the board
void _initializeBoard() {
List<List<chessPiece?>> newBoard = 
List.generate(8, (index) => List.generate(8, (index) => null));

// checking 
newBoard[3][3] = chessPiece(
    type: chessPieceType.king, 
    isWhite: true, 
    imagePath: 'lib/images/king.png');

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
    type: chessPieceType.knight, 
    isWhite: false, 
    imagePath: 'lib/images/knight.png');

    newBoard[0][6] = chessPiece(
    type: chessPieceType.knight, 
    isWhite: false, 
    imagePath: 'lib/images/knight.png');

    newBoard[7][1] = chessPiece(
    type: chessPieceType.knight, 
    isWhite: true, 
    imagePath: 'lib/images/knight.png');

    newBoard[7][6] = chessPiece(
    type: chessPieceType.knight, 
    isWhite: true, 
    imagePath: 'lib/images/knight.png');

// placing bishops
    newBoard[0][2] = chessPiece(
    type: chessPieceType.bishop, 
    isWhite: false, 
    imagePath: 'lib/images/bishop.png');

    newBoard[0][5] = chessPiece(
    type: chessPieceType.bishop, 
    isWhite: false, 
    imagePath: 'lib/images/bishop.png');

    newBoard[7][2] = chessPiece(
    type: chessPieceType.bishop, 
    isWhite: true, 
    imagePath: 'lib/images/bishop.png');

    newBoard[7][5] = chessPiece(
    type: chessPieceType.bishop, 
    isWhite: true, 
    imagePath: 'lib/images/bishop.png');
// placing queen
    newBoard[0][3] = chessPiece(
    type: chessPieceType.queen, 
    isWhite: false, 
    imagePath: 'lib/images/queen.png');

    newBoard[7][3] = chessPiece(
    type: chessPieceType.queen, 
    isWhite: true, 
    imagePath: 'lib/images/queen.png');
// placing king
    newBoard[0][4] = chessPiece(
    type: chessPieceType.king, 
    isWhite: false, 
    imagePath: 'lib/images/king.png');

    newBoard[7][4] = chessPiece(
    type: chessPieceType.king, 
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
    // if a piece is selected then we will be calculating its valid moves
    validMoves = calculateValidMoves(selectedRow, selectedColumn, selectedPiece);
  });
}

// calculating the valid moves for the selected piece
List<List<int>> calculateValidMoves(int row, int column, chessPiece? piece) {
  List<List<int>> candidateMoves = [];
  // direction for the colors
  int direction = piece!.isWhite ? -1 : 1;

  // case scenario for the piece type
  switch (piece.type) {
    case chessPieceType.pawn:
    // can move one square forward if the square is empty
    if(isInBoard(row + direction, column) &&
        board[row + direction][column] == null){
          candidateMoves.add([row + direction, column]);
        }

    // can move two squares forward if it is the first move and the square is empty
    if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)){
      if (isInBoard(row + 2 * direction, column) && 
      board[row + 2 * direction][column] == null &&
      board[row + direction][column] == null) {
        candidateMoves.add([row + 2 * direction, column]);
      }
    }
    // can capture diagonally if there is an opponent's piece
    if(isInBoard(row + direction, column - 1)&&
        board[row + direction][column - 1] != null &&
        board[row + direction][column - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, column - 1]);
        }
    
    if(isInBoard(row + direction, column + 1) &&
        board[row + direction] [column + 1] != null &&
        board[row + direction] [column + 1]!.isWhite != piece.isWhite){
          candidateMoves.add([row + direction, column + 1]);
        }

      break;
    case chessPieceType.rook:
      // rook can move straight in all four directions
      var directions = [
        [1, 0], // down
        [-1, 0], // up
        [0, 1], // right
        [0, -1] // left
      ];
      for(var direction in directions){
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newColumn = column + i * direction[1];
          if (!isInBoard(newRow, newColumn)) {
            break;
          }
          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]);
            }
            break;
          }
          candidateMoves.add([newRow, newColumn]);
          i++;
        }
      }

      break;
    case chessPieceType.knight:
    // possible 8 L moves for the knight
      var knightMoves = [
        [-2, -1], //up 2 left 1
        [-2, 1], //up 2 right 1
        [-1, -2], //up 1 left 2
        [-1, 2], //up 1 right 2
        [1, -2], //down 1 left 2
        [1, 2], //down 1 right 2
        [2, -1], //down 2 left 1
        [2, 1] //down 2 right 1 
      ];
      for (var move in knightMoves) {
        var newRow = row + move[0];
        var newColumn = column + move[1];
        if (!isInBoard(newRow, newColumn)) {
          continue;
        }
        if (board[newRow][newColumn] != null){
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]);
              
            }
          continue;
        }
        candidateMoves.add([newRow, newColumn]);
        }

      break;
    case chessPieceType.bishop:
      // moving diagonally in all four directions
      var directions = [
        [1, 1], // down right
        [1, -1], // down left
        [-1, 1], // up right
        [-1, -1] // up left
      ];

      for (var direction in directions){
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newColumn = column + i * direction[1];
          if (!isInBoard(newRow, newColumn)) {
            break;
      }
      if (board[newRow][newColumn] != null) {
        if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
          candidateMoves.add([newRow, newColumn]);
        }
        break;
        
      }
      candidateMoves.add([newRow, newColumn]);
      i++;
        }
    }
      
      break;
    case chessPieceType.queen:
      // can move in all directions
      var directions = [
        [1, 0], // down
        [-1, 0], // up
        [0, 1], // right
        [0, -1], // left
        [1, 1], // down right
        [1, -1], // down left
        [-1, 1], // up right
        [-1, -1] // up left
      ]; 
      for (var direction in directions) {
        var i = 1;
        while (true) {
          var newRow = row + i * direction[0];
          var newColumn = column + i * direction[1];
          if (!isInBoard(newRow, newColumn)) {
            break;
          }
          if (board[newRow][newColumn] != null) {
            if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newColumn]);
            }
            break;
          }
          candidateMoves.add([newRow, newColumn]);
          i++;
        }
      }
      break;
    case chessPieceType.king:
      // can move one square in any direction
      var directions = [
        [1, 0], // down
        [-1, 0], // up
        [0, 1], // right
        [0, -1], // left
        [1, 1], // down right
        [1, -1], // down left
        [-1, 1], // up right
        [-1, -1] // up left
      ];
      for (var direction in directions) {
        var newRow = row + direction[0];
        var newColumn = column + direction[1];
        if (!isInBoard(newRow, newColumn)) {
          continue;
        }
        if (board[newRow][newColumn] != null) {   
          if (board[newRow][newColumn]!.isWhite != piece.isWhite) {
            candidateMoves.add([newRow, newColumn]);
          }
          continue;
        }
        candidateMoves.add([newRow, newColumn]);
      }

      break;
    default:
    
  } 
      return candidateMoves;

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
            // checking if the square is a valid move
            bool isValidMove = false;
            for (var position in validMoves) {
              if (position[0] == y && position[1] == x) {
                isValidMove = true;
                break;
                
              }
            }
            return Square(
              isWhite: isWhite, 
              piece: board[y][x],
              isSelected: isSelected,
              isValidMove: isValidMove,
              onTap: () => _selectedPiece(y, x),
            );
          },
          itemCount: 8*8,
        ),
    );
  }
}