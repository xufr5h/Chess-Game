import 'package:flutter/material.dart';

class DeadPieces extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  final double size;

  const DeadPieces({
    super.key,
    required this.imagePath,
    required this.isWhite,
    this.size = 10.0,
});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      color: isWhite ? Colors.grey[400] : Colors.grey[800],
      );
  }
}