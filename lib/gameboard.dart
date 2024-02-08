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

  ChessPiece? lastMovedPiece;
  List<int>? lastMoveStart;
  List<int>? lastMoveEnd;

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
    //buildBoardFromFEN("r6k/pp2r2p/4Rp1Q/3p4/8/1N1P2R1/PqP2bPP/7K");
  }
  //BUILD NORMAL BOARD
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

  //BUILD PUZZLE BOARD OFF FEN
  void buildBoardFromFEN(String fen) {
  List<List<ChessPiece?>> newBoard = 
      List.generate(8, (index) => List.generate(8, (index) => null));
  List<String> fenParts = fen.split(' ');
  List<String> rows = fenParts[0].split('/');

  for (int row = 0; row < 8; row++) {
    int col = 0;
    for (int index = 0; index < rows[row].length; index++) {
      String char = rows[row][index];
      if (int.tryParse(char) != null) {
        col += int.parse(char);
      } else {
        newBoard[row][col] = createPieceFromFENChar(char);
        col++;
      }
    }
  }

  // Update the board state and other game-related states if necessary
  setState(() {
    board = newBoard;
    isWhiteTurn = fenParts[0] == true; // Update turn based on FEN

    // You can add more state updates based on other parts of the FEN string like castling rights, en passant, etc.
  });
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
      validMoves = calculateRealValidMoves(selectedRow, selectedCol, selectedPiece, true);
    });
  }

  //Calculate RAW valid moves
  List<List<int>> calculateRawValidMoves(
    int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }
    //different directions based on their color
    int direction = piece.isWhite ? -1 : 1;

    switch(piece.type){
      case ChessPieceType.pawn:
        //checks if square is not occupied
        if(isInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col, 0]);
        }
        //first pawn move goes 2 spaces
        if((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if(isInBoard(row + 2 * direction, col) &&
           board[row+2*direction][col] == null &&
           board[row + direction][col] == null) {
           candidateMoves.add([row + 2 * direction, col, 0]);
          }
        }
        //take piece if diagonal
        if(isInBoard(row + direction, col - 1) &&
         board[row + direction][col - 1] != null &&
         board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col-1, 1]);
        }
        if(isInBoard(row + direction, col + 1) &&
         board[row + direction][col + 1] != null &&
         board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1, 1]);
        }

        //en passant
        if (row == (piece.isWhite ? 3 : 4)) { // Pawns can only capture en passant on these ranks
          List<int> sides = [col - 1, col + 1];
          for (int sideCol in sides) {
            if (sideCol >= 0 && sideCol < 8) {
              ChessPiece? adjacentPiece = board[row][sideCol];
              // Check if the adjacent piece is a pawn of the opposite color and it just moved 2 squares
              if (adjacentPiece != null &&
                  adjacentPiece.type == ChessPieceType.pawn &&
                  adjacentPiece.isWhite != piece.isWhite &&
                  lastMovedPiece == adjacentPiece &&
                  lastMoveStart![0] == (piece.isWhite ? 1 : 6) &&
                  lastMoveEnd![0] == (piece.isWhite ? 3 : 4)) {
                // Add en passant capture move
                candidateMoves.add([piece.isWhite ? 2 : 5, sideCol, 1]);
              }
            }
          }
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
                candidateMoves.add([newRow, newCol, 1]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol, 0]);//move normally
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
              candidateMoves.add([newRow, newCol, 1]); //capture
            }
            continue; //blocked
          }
          candidateMoves.add([newRow, newCol, 0]); //move normally
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
                candidateMoves.add([newRow, newCol, 1]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol, 0]); //move normally
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
                candidateMoves.add([newRow, newCol, 1]); //capture
              }
              break; //blocked
            }
            candidateMoves.add([newRow, newCol, 0]); //move normally
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
              candidateMoves.add([newRow, newCol, 1]); //capture
            }
            continue;
          }

          candidateMoves.add([newRow,newCol, 0]); //move normally
        }
        break;
      default:
    }

    return candidateMoves;
  }
 
  //Calculate Real Valid Moves
  List<List<int>> calculateRealValidMoves(int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    //filter moves if they result in king check
    if(checkSimulation) {
      for(var move in candidateMoves){
        int endRow = move[0];
        int endCol = move[1];
        if(simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }

    return realValidMoves;
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

      // If moved piece is a king, update its position
    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    if (selectedPiece!.type == ChessPieceType.pawn &&
      lastMovedPiece != null &&
      lastMovedPiece!.type == ChessPieceType.pawn &&
      (newRow == 2 || newRow == 5) && // Capturing pawn must land on these ranks
      (newRow - selectedRow).abs() == 1 && // Must move diagonally (1 row difference)
      (newCol - selectedCol).abs() == 1 && // Must move diagonally (1 column difference)
      lastMoveStart![0] == (isWhiteTurn ? 1 : 6) && // Last moved pawn must have moved from its original position
      lastMoveEnd![0] == (isWhiteTurn ? 3 : 4) && // Last moved pawn must have moved two squares
      lastMoveEnd![1] == newCol) { // Last moved pawn must be in the same column as the capturing pawn's destination
    // Remove the captured pawn
    board[lastMoveEnd![0]][newCol] = null;

    // Add the captured pawn to the list of taken pieces
    if(isWhiteTurn) {
      blackPiecesTaken.add(lastMovedPiece!);
    } else {
      whitePiecesTaken.add(lastMovedPiece!);
    }
  }

    //move peice and clear old spot
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    //check for check
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    //save last moved piece for  en passant
    lastMovedPiece = selectedPiece;
    lastMoveStart = [selectedRow, selectedCol];
    lastMoveEnd = [newRow, newCol];

    

    //clear selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    //check if its checkmate
    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("CHECKMATE!"),
          actions: [
            TextButton(
              onPressed: resetGame,
              child: const Text("Play Again")
            ),
          ]
        ),
       );
    }

    //change turn
    isWhiteTurn = !isWhiteTurn;
  }

  //IS KING IN CHECK
  bool isKingInCheck(bool isWhiteKing) {
    //get position of king
    List<int> kingPosition = isWhiteKing ? whiteKingPosition : blackKingPosition;

    //check if a piece can attack the king
    for (int i = 0; i < 8; i++){
      for (int j = 0; j < 8; j++){
        //skip empty square or same color
        if(board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves = 
          calculateRealValidMoves(i, j, board[i][j], false);

        //check to see if king is in any piece's valid moves
        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] &&
             move[1] == kingPosition[1])){
              return true;
        }  
      }
    }

    return false;
  }

  // Simulate a future move
  bool simulatedMoveIsSafe(ChessPiece piece, int startRow,int startCol, int endRow, int endCol) {
    //save current board state
    ChessPiece? originialDestinationPiece = board[endRow][endCol];

    //if piece is king and update to new one
    List<int>? originalKingPosition;
    if(piece.type == ChessPieceType.king) {
      originalKingPosition =
        piece.isWhite ? whiteKingPosition : blackKingPosition;
    
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }
    //simulate move
    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;
    //check if own king is under attack
    bool kingInCheck = isKingInCheck(piece.isWhite);
    //restor baord
    board[startRow][startCol] = piece;
    board[endRow][endCol] = originialDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if(piece.isWhite){
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }

    }
    //if king in check = true, return false as in not safe
    return !kingInCheck;
  }

  //Check for checkmate
  bool isCheckMate(bool isWhiteKing) {
    //if king is not in check then its not checkmate
    if(!isKingInCheck(isWhiteKing)) {
      return false;
    }
    //if there is a legal move it is not checkmate
    for(int i = 0; i<8; i++){
      for(int j = 0; j<8; j++){
        //skip empty squares or opposite color pieces
        if(board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves = calculateRealValidMoves(i, j, board[i][j], true);

        //if this piece has valid moves it is not checkmate
        if(pieceValidMoves.isNotEmpty){
          return false;
        }
      }
    }
    //checkmate!
    return true;
  }

  //Genereate FEN
  String generateFEN() {
    String fen = "";

    for (int row = 0; row < 8; row++) {
      int emptyCount = 0;

      for (int col = 0; col < 8; col++) {
        ChessPiece? piece = board[row][col];

        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            fen += emptyCount.toString();
            emptyCount = 0;
          }
          String pieceCode = getPieceCode(piece);
          fen += piece.isWhite ? pieceCode.toUpperCase() : pieceCode.toLowerCase();
        }
      }

      if (emptyCount > 0) {
        fen += emptyCount.toString();
      }

      if (row < 7) {
        fen += '/';
      }
  }

  // Add the active color, castling availability, en passant, halfmove, and fullmove
  fen += ' ${isWhiteTurn ? 'w' : 'b'}';
  // Placeholder for castling availability, en passant, halfmove clock, and fullmove number. You might need to adjust these based on your game state.
  fen += ' - - 0 1';

  return fen;
}



  void resetGame() {
    // Navigator.pop(context);
    _initBoard();
    // buildBoardFromFEN("r6k/pp2r2p/4Rp1Q/3p4/8/1N1P2R1/PqP2bPP/7K");
    checkStatus = false;
    isWhiteTurn = true;
    whitePiecesTaken.clear();
    blackPiecesTaken.clear();
    setState(() {
      whiteKingPosition = [7,4];
      blackKingPosition = [0,4];
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

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

            

            //Game Status
            Text(checkStatus ? "CHECK!" : ""),

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
                    bool isCaptureMove = false;

                    for (var position in validMoves) {
                      if(position[0] == row && position[1] == col){
                        isValidMove = true;
                        isCaptureMove = position.length > 2 && position[2] == 1;
                      }
                    }
              
              
                    return Square(
                      isWhite: isWhite(index),
                      piece: board[row][col],
                      isSelected: isSelected,
                      isValidMove: isValidMove,
                      onTap: () => pieceSelected(row, col),
                      isCaptureMove: isCaptureMove,
                    );
                  },
                  ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered))
                          return Colors.blue.withOpacity(0.04);
                        if (states.contains(MaterialState.focused) ||
                            states.contains(MaterialState.pressed))
                          return Colors.blue.withOpacity(0.12);
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: resetGame,
                  child: const Text('Reset'),
                ),
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



