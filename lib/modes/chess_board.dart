import 'package:chess_app/components/dead_pieces.dart';
import 'package:chess_app/components/pieces.dart';
import 'package:chess_app/components/square.dart';
import 'package:chess_app/modes/game_mode.dart';
import 'package:chess_app/helper/helper_method.dart';
import 'package:chess_app/profile/game_stats.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../helper/user_score.dart';
import 'package:chess_app/profile/profile.dart';



class ChessBoard extends StatefulWidget {
  const ChessBoard({super.key});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  bool _isDrawerOpen = false; 

// creating a 2D chess list representing the chess board
 late List<List<chessPiece?>> board;

//  selected piece on the board
chessPiece? selectedPiece;
// setting the default selected piece to null
int selectedRow = -1;
int selectedColumn = -1;

// creating a list of valid moves for the selected piece
List<List<int>> validMoves = [];

// list of black pieces that has been captured
List<chessPiece> blackCapturedPieces = [];

// list of white pieces that has been captured
List<chessPiece> whiteCapturedPieces = []; 

// indicating the turns 
bool isWhiteTurn = true;

// gameId
String? currentGameId;

// Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final User? _currentUser = FirebaseAuth.instance.currentUser;

// keepoing track of the kings position
List<int> whiteKingPosition = [7, 4];
List<int> blackKingPosition = [0, 4];
bool checkStatus = false; 

@override
void initState() {
  super.initState();
  _initializeBoard();
  _createNewGame();
}

// creating a new game in Firestore
void _createNewGame() async {
  try {
    final docRef = await _firestore.collection('games').add({
      'playerwhite': _currentUser?.uid,
      'playerblack': null,
      'moves': [],
      'status': 'ongoing',
      'createdAt': FieldValue.serverTimestamp(),
      'timeControl': '5+0'
    });
    currentGameId = docRef.id;
  } catch (e) {
    debugPrint('Error creating new game: $e');
  }
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
    // first time selecting a piece
    if (selectedPiece == null && board[row][column] != null) {
      if (board[row][column]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][column];
        selectedRow = row;
        selectedColumn = column;
      } else {
        // if the piece is not of the current player's turn, do nothing
        return;
        
      }
    }
    // there is already a selected piece but user selects another one of their piece
    else if(board[row][column] != null && 
        board[row][column]!.isWhite == selectedPiece!.isWhite) {
      // deselect the piece
      selectedPiece = board[row][column];
      selectedRow = row;
      selectedColumn = column;

    }
    // if the piece is selected and user taps on another square that is a valid move
    else if (selectedPiece != null && 
        validMoves.any((element) => element[0] == row && element[1] == column)) {
      // move the piece to the new square
      movePiece(row, column);
    } 
     else {
      // if there is no piece on the square, deselect the piece
      selectedPiece = null;
      selectedRow = -1;
      selectedColumn = -1;  
    }
    // if a piece is selected then we will be calculating its valid moves
    validMoves = calculateRealValidMoves(selectedRow, selectedColumn, selectedPiece, true);
  });
}

// calculating the valid moves for the selected piece
List<List<int>> calculateValidMoves(int row, int column, chessPiece? piece) {
  List<List<int>> candidateMoves = [];

  if (piece == null) {
    return []; // if no piece is selected, return empty list
    
  }

  // direction for the colors
  int direction = piece.isWhite ? -1 : 1;

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

// calculting the real valid moves
List<List<int>>calculateRealValidMoves (int row, int column, chessPiece ? piece, bool checkSimulation){
  List<List<int>> realValidMoves = [];
  List<List<int>> candidateMoves = calculateValidMoves(row, column, piece);

  // cheking the king checks after generating all possible moves 
  if (checkSimulation) {
    for (var move in candidateMoves) {
      int endRow = move[0];
      int endColumn = move[1];
       if (simulatedMoveIsSafe(piece!, row, column, endRow, endColumn)) {
        realValidMoves.add(move);
      }
    }
    }else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }


// moving the piece to the selected square
void movePiece(int newRow, int newColumn) async {
  // Make a copy of the current piece and clear the original position
  chessPiece? movingPiece = selectedPiece;
  
  setState(() {
    // Capture logic
    if (board[newRow][newColumn] != null) {
      var capturedPiece = board[newRow][newColumn];
      if (capturedPiece!.isWhite) {
        whiteCapturedPieces.add(capturedPiece);
      } else {
        blackCapturedPieces.add(capturedPiece);
      }
    }

    // Move the piece
    board[newRow][newColumn] = movingPiece;
    board[selectedRow][selectedColumn] = null;

    // Update king position if needed
    if (movingPiece!.type == chessPieceType.king) {
      if (movingPiece.isWhite) {
        whiteKingPosition = [newRow, newColumn];
      } else {
        blackKingPosition = [newRow, newColumn];
      }
    }

    // Check for check
    checkStatus = isKingInCheck(!isWhiteTurn);
    if (isCheckmate(!isWhiteTurn)) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('CHECKMATE!'),
            content: Text('${isWhiteTurn ? "White" : "Black"} wins!'),
            actions: [
              TextButton(
                onPressed: resetGame,
                child: const Text('Play Again'),
              ),
            ],
          ),
        );
      });

      _recordGameResult(isWhiteTurn);
      return;
    }
    isWhiteTurn = !isWhiteTurn;
    // Reset selection
    selectedPiece = null;
    selectedRow = -1;
    selectedColumn = -1;
    validMoves = [];
  });

  // Rest of your Firestore and checkmate logic...
  if (currentGameId != null) {
    await _firestore.collection('games').doc(currentGameId).update({
      'moves': FieldValue.arrayUnion([_getMoveNotation(newRow, newColumn)]),
      'lastMoveAt': FieldValue.serverTimestamp(),
    });
  }
}

// recording the game result in Firestore
Future<void> _recordGameResult(bool whiteWon) async {
  final userScore = Provider.of<UserScore>(context, listen: false);
  if (currentGameId == null) return;
  try {
    // Updating the game status
    await _firestore.collection('games').doc(currentGameId).update({
      'winner': whiteWon ? _currentUser?.uid : 'opponent',
      'status': 'completed',
      'endTime': FieldValue.serverTimestamp(),
    });
    // update the local user score
    bool isWhite = _currentUser?.uid ==FirebaseAuth.instance.currentUser?.uid;
    bool userWon = (whiteWon && isWhite) || (!whiteWon && !isWhite);
    bool userLost = !userWon;
    
    if (_currentUser != null) {
      final userRef = _firestore.collection('users').doc(_currentUser!.uid);
        await userRef.update({
        'gamesPlayed': FieldValue.increment(1),
        'gamesWon': FieldValue.increment(whiteWon ? 1 : 0),
        'gamesLost': FieldValue.increment(userLost ? 1 : 0),
        'rating': FieldValue.increment(userWon ? 15 : -15),
        'gameRefs': FieldValue.arrayUnion([currentGameId!]),
      });
      userScore.recordResult(isWin: userWon, isDraw: false);
    }
    print('Game result recorded successfully');
  } catch (e) {
    debugPrint('Error recording game result: $e');
  }
}

// notation for the move
String _getMoveNotation(int newRow, int newColumn){
  // converting to the chess notation
  final fromFile = String.fromCharCode('a'.codeUnitAt(0)+selectedColumn);
  final fromRank = (8-selectedRow).toString();
  final toFile = String.fromCharCode('a'.codeUnitAt(0)+newColumn);
  final toRank = (8-newRow).toString();
  // checking if its a capture
  bool isCapture = board[newRow][newColumn] != null;

  // getting piece type
  final pieceSymbol = selectedPiece!.type == chessPieceType.pawn
    ? ''
    : _getPieceSymbol(selectedPiece!);
  
  // building the notation
  String notation = pieceSymbol;

  // including the source file for pawns
  if (isCapture && selectedPiece!.type == chessPieceType.pawn) {
    notation += fromFile;
  }

  // adding the capture symbol
  if (isCapture) {
    notation += 'x';
  }

  // adding the destination square
  notation += toFile + toRank;
  return notation;
}
  // helper function to get piece symbol
  String _getPieceSymbol(chessPiece piece){
    switch (piece.type) {
      case chessPieceType.king: return 'K';
      case chessPieceType.queen: return 'Q';
      case chessPieceType.rook: return 'R';
      case chessPieceType.bishop: return 'B';
      case chessPieceType.knight: return 'N';
      default: return '';
    }
  }

  // checking if the king is in check
bool isKingInCheck(bool isWhiteKing) {
  // Get the position of the king
  List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;
  
  // Check all opponent pieces
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      // Skip empty squares and own pieces
      if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
        continue;
      }
      
      // Get valid moves for this opponent piece
      List<List<int>> pieceValidMoves = calculateValidMoves(i, j, board[i][j]);
      
      // Check if any move targets the king's position
      for (var move in pieceValidMoves) {
        if (move[0] == kingPosition[0] && move[1] == kingPosition[1]) {
          return true;
        }
      }
    }
  }
  return false;
}

// simulating a future move to see if its safe
bool simulatedMoveIsSafe(chessPiece piece, int startRow, int startColumn, int endRow, int endColumn) {
// save the current board state
chessPiece? originalDestinationPiece = board[endRow][endColumn];
// if the piece is the king, save its  current position and then update to the new one 
List<int>? originalKingPosition;
  if (piece.type==chessPieceType.king) {
  originalKingPosition = 
      piece.isWhite ? whiteKingPosition : blackKingPosition;
    if (piece.isWhite) {
      whiteKingPosition = [endRow, endColumn];
  } else {
    blackKingPosition = [endRow, endColumn];
    }
  }
// simulate the move
board[endRow][endColumn] = piece;
board[startRow][startColumn] = null;

//check if own king is under attack
bool kingInCheck = isKingInCheck(piece.isWhite);

// restore board to original position
board[startRow][startColumn] = piece;
board[endRow][endColumn] = originalDestinationPiece;

// restoring its original position if king 
  if (piece.type == chessPieceType.king) {
    if (piece.isWhite) {
      whiteKingPosition = originalKingPosition!;
    } else {
      blackKingPosition = originalKingPosition!;
    }
  }
  return !kingInCheck; 
}

// checking if its a checkmate 
bool isCheckmate(bool isWhiteKing){
  // if the king is not in check then its not a checkmate 
  if (!isKingInCheck(isWhiteKing)) {
    return false;
  }
  // if there is one legal move then its not a checkmate
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      // skipping empty squares and pieces of other color
      if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
        continue;
      }
      List<List<int>> pieceValidMoves = 
          calculateRealValidMoves(i, j, board[i][j], true);
      // if there is a valid move for the piece then its not a checkmate
      if (pieceValidMoves.isNotEmpty) {
        return false;
      }
    }
  }
  // if both conditions are false then its a checkmate
  return true;
}

// resetting the game
void resetGame() {
  Navigator.pop(context);
  
  setState(() {
    _initializeBoard();

    checkStatus = false;
    isWhiteTurn = true;

    whiteCapturedPieces.clear();
    blackCapturedPieces.clear();

    whiteKingPosition = [7, 4];
    blackKingPosition = [0, 4];

    selectedPiece = null;
    selectedRow = -1;
    selectedColumn = -1;
    validMoves = [];
  });
}
// confirmation dialog for home button
void homeConfirmation(){
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      backgroundColor: const Color.fromARGB(255, 35, 44, 49),
      title: const Text('Are you sure you want to go back to the home page?', style: TextStyle(color: Colors.white, fontSize: 20),),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child:  Text('Cancel', style: TextStyle(color: Color.fromARGB(255, 72, 161, 58), fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const GameMode()),
            );
          },
          child: Text('Yes', style: TextStyle(color: Color.fromARGB(255, 72, 161, 58), fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:  const Color.fromARGB(255, 52, 52, 52),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Online Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 31, 28, 28),
      ),
      body: Stack(
        children: [
          Column(
          children: [
            // white pieces that has been captured
            const SizedBox(height: 20),
            // game turn
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('lib/images/online.jpeg'),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: !isWhiteTurn
                                ? [
                                    const BoxShadow(
                                      color: Colors.lightGreenAccent,
                                      spreadRadius: 2,
                                      blurRadius: 0,
                                    ),
                                  ]
                                : null,
                          ), 
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Black Player',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !isWhiteTurn ? Colors.green : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: whiteCapturedPieces.length,
                        itemBuilder: (context, index){
                          chessPiece piece = whiteCapturedPieces[index];
                          return DeadPieces(
                            imagePath: piece.imagePath, 
                            isWhite: piece.isWhite,
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 60),
  
            // chess board
            Expanded(
              flex: 4,
              child: GridView.builder(
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
                    // checking if the king is in check
                    bool kingUnderCheck= false;
                    if (board[y][x]?.type == chessPieceType.king) {
                      kingUnderCheck = isKingInCheck(board[y][x]!.isWhite);
                    }
                    return Square(
                      isWhite: isWhite, 
                      piece: board[y][x],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => _selectedPiece(y, x),
                      isInCheck: kingUnderCheck,
                    );
                  },
                  itemCount: 8*8,
                ),
            ),
            // white player
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage('lib/images/cat.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: isWhiteTurn
                                  ? [
                                      const BoxShadow(
                                        color: Colors.lightGreenAccent,
                                        spreadRadius: 2,
                                        blurRadius: 0,
                                      ),
                                    ]
                                  : null,
                            ), 
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'White Player',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isWhiteTurn ? Colors.green : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: blackCapturedPieces.length,
                      itemBuilder: (context, index){
                        chessPiece piece = blackCapturedPieces[index];
                        return DeadPieces(
                          imagePath: piece.imagePath, 
                          isWhite: piece.isWhite,
                        );
                      }
                    ),
                  ),
                    ],
                  ),
                ),
          
             
          ],
        ),
        if (_isDrawerOpen)
          GestureDetector(
            onTap: () => setState(() => _isDrawerOpen = false),
            child: Container(
              color: Colors.black54, // Semi-transparent black
            ),
          ),

        // Drawer - positioned on top of everything
        Positioned(
          right: _isDrawerOpen ? 0 : -300, // Animation offset
          top: 0,
          bottom: 0,
          width: 300, // Match your drawer width
          child: CustomDrawer(
            isDrawerOpen: _isDrawerOpen,
            onCloseDrawer: () => setState(() => _isDrawerOpen = false),
          ),
        ),
        ]
      ),

       bottomNavigationBar: // footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 31, 28, 28),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home
                  GestureDetector(
                    onTap: homeConfirmation,
                    child: Icon(Icons.home, color: const Color.fromARGB(255, 255, 255, 255), size: 34,),
                      
                  ),
                  // Profile
                  GestureDetector(
                    onTap: () => setState(() => _isDrawerOpen = !_isDrawerOpen),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('lib/images/cat.jpeg'),
                    )
                    
                  )
                ],
              ),
            ),
    );
  }
}