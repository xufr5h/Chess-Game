import 'package:flutter/material.dart';

class DeadPieces extends StatelessWidget {
  final String imagePath;
  final bool isWhite;
  final double size;

  const DeadPieces({
    super.key,
    required this.imagePath,
    required this.isWhite,
    this.size = 24.0,
});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        imagePath,
        color: isWhite ? Colors.white : Colors.black,
        fit: BoxFit.cover,
      ),
    );
  }
}