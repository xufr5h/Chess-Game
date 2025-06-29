import 'package:chess_app/components/pieces.dart';

bool isInBoard(int row, int column) {
  return row >= 0 && row < 8 && column >= 0 && column < 8;
}

