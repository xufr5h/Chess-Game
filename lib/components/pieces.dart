enum chessPieceType{ 
  pawn,
  knight,
  bishop,
  rook,
  queen,
  king
}
class chessPiece{
  final chessPieceType type;
  final bool isWhite;
  final String imagePath;

chessPiece({
  required this.type,
  required this.isWhite,
  required this.imagePath,
});
}