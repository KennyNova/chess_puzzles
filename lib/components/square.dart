import 'package:flutter/material.dart';
import 'package:flutter_chess_puzzle/components/piece.dart';
import 'package:flutter_chess_puzzle/values/colors.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  final bool isSelected;
  final bool isValidMove;
  final bool isCaptureMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValidMove,
    required this.isCaptureMove,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;

    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValidMove && !isCaptureMove) { // Non-capture valid move
      squareColor = Colors.green[300];
    } else if (isValidMove && isCaptureMove) { // Capture move
      squareColor = Colors.red; // Use red for capture moves
    } else {
      squareColor = isWhite ? foregroundColor : backgroundColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        margin: EdgeInsets.all(isValidMove ? 8 : 0),
        child: piece != null ? Image.asset(piece!.imagePath) : null,
      ),
    );
  }
}