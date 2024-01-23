import 'package:flutter/material.dart';
import 'package:flutter_chess_puzzle/components/dead_piece.dart';
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

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  //list of valid moves for selected piece
  //each move is represented as a row and col
  List<List<int>> validMoves = [];

  //list of white pieces captured
  List<ChessPiece> whitePiecesTaken = [];

  //list of black pieces captured
  List<ChessPiece> blackPiecesTaken = [];

  //Boolean for whose turn
  bool isWhiteTurn = true;

  //init posotion of king
  List<int> whiteKingPosition = [7,4];
  List<int> blackKingPosition = [0,4];
  bool checkStatus = false;

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
        imagePath: 'lib/images/pb.jpg',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'lib/images/pw.jpg',
      );
    }

    //Place rooks
    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/images/rb.jpg',
      );
      newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: false,
        imagePath: 'lib/images/rb.jpg',
      );
      newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/images/rw.jpg',
      );
      newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        isWhite: true,
        imagePath: 'lib/images/rw.jpg',
      );
    //Place knights
      newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/images/nb.jpg',
      );
      newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: false,
        imagePath: 'lib/images/nb.jpg',
      );
      newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/images/nw.jpg',
      );
      newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        isWhite: true,
        imagePath: 'lib/images/nw.jpg',
      );
    //Place bishops
      newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/images/bb.jpg',
      );
      newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: false,
        imagePath: 'lib/images/bb.jpg',
      );
      newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/images/bw.jpg',
      );
      newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        isWhite: true,
        imagePath: 'lib/images/bw.jpg',
      );
    //Place queens
      newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: false,
        imagePath: 'lib/images/qb.jpg',
      );
      newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        isWhite: true,
        imagePath: 'lib/images/qw.jpg',
      );
    //Place kings
    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: false,
        imagePath: 'lib/images/kb.jpg',
    );
    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        isWhite: true,
        imagePath: 'lib/images/kw.jpg',
    );

    board = newBoard;
  }

  //USER SELECTED A PIECE
  void pieceSelected(int row, int col) {
    setState(() {
      //No piece selected before
      if (selectedPiece == null && board[row][col] != null) {
        if(board[row][col]!.isWhite == isWhiteTurn ){
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
      }
      //piece selected before
      else if (board[row][col]  != null &&
                  board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }


      //move piece
      else if(selectedPiece != null &&
                validMoves.any((element) => element[0] == row && element[1] == col)){
        movePiece(row, col);
       }
      
      
      //calculate moves
      validMoves = calculateRawValidMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  //Calculate RAW valid moves
  List<List<int>> calculateRawValidMoves(
    int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    //different directions based on their color
    int direction = piece!.isWhite ? -1 : 1;

    switch(piece.type){
      case ChessPieceType.pawn:
        //checks if square is not occupied
        if(isInBoard(row + direction, col) &&
         board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //first pawn move goes 2 spaces
        if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if(isInBoard(row + 2 * direction, col) &&
           board[row+2*direction][col] == null &&
           board[row + direction][col] == null) {
           candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //take piece if diagonal
        if(isInBoard(row + direction, col - 1) &&
         board[row + direction][col - 1] != null &&
         board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col-1]);
        }
        if(isInBoard(row + direction, col + 1) &&
         board[row + direction][col + 1] != null &&
         board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
      //horizontal vertical check
        var directions = [
          [-1,0], //up
          [1,0], //down
          [0,-1], //left
          [0,1], //right
        ];

        for (var direction in directions) {
          var i = 1;
          while(true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)) {
              break;
            }
            if(board[newRow][newCol] != null) {
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var knightMoves = {
          [-2,-1], //up 2 left 1
          [-2,1], //up 2 right 1
          [-1,-2], //up 1 left 2
          [-1,2], //up 1 right 2
          [1,-2], //down 1 left 2
          [1,2], //down 1 right 2
          [2,-1], //down 2 left 1
          [2,1], //down 2 right 1
        };
        for(var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if(!isInBoard(newRow, newCol)) {
            continue;
          }
          if(board[newRow][newCol] != null){
            if (board[newRow][newCol]!.isWhite != piece.isWhite){
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1,-1], //up left
          [-1,1], //up right
          [1,-1], //down left
          [1,1], //down right
        ];

        for(var direction in directions) {
          var i = 1;
          while(true){
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)) {
              break;
            }
            if(board[newRow][newCol] != null){
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.queen:
        var directions = [
          [-1,0], //up
          [1,0], //down
          [0,-1], //left
          [0,1], //right
          [-1,-1], //up left
          [-1,1], //up right
          [1,-1], //down left
          [1,1], //down right
        ];

        for(var direction in directions) {
          var i = 1;
          while(true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if(!isInBoard(newRow, newCol)){
              break;
            }
            if(board[newRow][newCol] != null) {
              if(board[newRow][newCol]!.isWhite != piece.isWhite){
                candidateMoves.add([newRow, newCol]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
            [-1,0], //up
            [1,0], //down
            [0,-1], //left
            [0,1], //right
            [-1,-1], //up left
            [-1,1], //up right
            [1,-1], //down left
            [1,1], //down right
          ];
        
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if(!isInBoard(newRow, newCol)){
            continue;
          }
          if (board[newRow][newCol] != null) {
            if(board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]); //capture
            }
            continue;
          }

          candidateMoves.add([newRow,newCol]);
        }
        break;
      default:
    }

    return candidateMoves;
  }
 
  //MOVE PIECE
  void movePiece( int newRow, int newCol) {

    //if new spot has enemy piece
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if(capturedPiece!.isWhite){
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    //move peice and clear old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //check for check
    if (isKingInCheck()) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }


    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });


    //change turn
    isWhiteTurn = !isWhiteTurn;
  }

  //IS KING IN CHECk
  bool isKingInCheck(bool isWhiteKing) {
    //get position of king
    List<int> blackKingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [

            //White Pieces taken
            Expanded(
              child: GridView.builder(
                itemCount: whitePiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8 ),  
                    itemBuilder: (context, index) => DeadPiece(
                      imagePath: whitePiecesTaken[index].imagePath,
                      isWhite: true,
                    ),
                  ),
            ),

            //-=CHESS BOARD=-
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: 8*8,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: 
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8 ),
                  itemBuilder: (context, index) {
              
                    //get row and col position of this square
                    int row = index ~/8;
                    int col = index % 8;
              
                    bool isSelected = selectedRow == row && selectedCol == col;
              
                    //check if valid move
                    bool isValidMove = false;
                    for (var position in validMoves) {
                      if(position[0] == row && position[1] == col){
                        isValidMove = true;
                      }
                    }
              
              
                    return Square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => pieceSelected(row, col),
                    );
                  },
                  ),
            ),


            //Black Pieces taken
            Expanded(
              child: GridView.builder(
                itemCount: blackPiecesTaken.length,
                physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8 ),  
                    itemBuilder: (context, index) => DeadPiece(
                      imagePath: blackPiecesTaken[index].imagePath,
                      isWhite: false,
                    ),
                  ),
            ),
          ],
        )
        );
  }
}
