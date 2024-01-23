import 'package:flutter/material.dart';
import 'package:flutter_chess_puzzle/components/piece.dart';
import 'package:flutter_chess_puzzle/components/square.dart';
import 'package:flutter_chess_puzzle/helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();

}

class _GameBoardState extends State<GameBoard> {

  late List<List<ChessPiece?>> board;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {

    //fills board with nulls
    List<List<ChessPiece?>> newBoard = 
        List.generate(8, (index) => List.generate(8, (index) => null));

    //Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'lib/images/bp.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/images/wp.png',
      );
    }

    //Place rooks

    //Place knights

    //Place bishops

    //Place queens

    //Place kings
    board = newBoard;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GridView.builder(
          itemCount: 8*8,
          physics: const NeverScrollableScrollPhysics(),
            gridDelegate: 
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8 ),
            itemBuilder: (context, index) {

              //get row and col position of this square
              int row = index ~/8;
              int col = index % 8;

              return Square(isWhite: isWhite(index),
              piece: board[row][col]);
            },
            )
        );
  }
}
