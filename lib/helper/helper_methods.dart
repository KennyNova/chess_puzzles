import 'package:flutter_chess_puzzle/components/piece.dart';

bool isWhite(int index) {
  int x = index ~/ 8;
              int y = index % 8;

              bool isWhite = (x + y) % 2 == 0;

              return isWhite;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}

String getPieceCode(ChessPiece piece) {
  switch (piece.type) {
    case ChessPieceType.pawn:
      return 'p';
    case ChessPieceType.knight:
      return 'n';
    case ChessPieceType.bishop:
      return 'b';
    case ChessPieceType.rook:
      return 'r';
    case ChessPieceType.queen:
      return 'q';
    case ChessPieceType.king:
      return 'k';
    default:
      return ''; // Just in case
  }
}

ChessPiece? createPieceFromFENChar(String fenChar) {
  bool isWhite = fenChar.toUpperCase() == fenChar;
  ChessPieceType? type;

  switch (fenChar.toLowerCase()) {
    case 'p':
      type = ChessPieceType.pawn;
      break;
    case 'n':
      type = ChessPieceType.knight;
      break;
    case 'b':
      type = ChessPieceType.bishop;
      break;
    case 'r':
      type = ChessPieceType.rook;
      break;
    case 'q':
      type = ChessPieceType.queen;
      break;
    case 'k':
      type = ChessPieceType.king;
      break;
  }

  if (type != null) {
    return ChessPiece(
      type: type,
      isWhite: isWhite,
      imagePath: 'lib/images/${fenChar.toLowerCase()}${isWhite ? 'w' : 'b'}.jpg',
    );
  }
  return null;
}

String getImagePathForPieceType(ChessPieceType type, bool isWhite) {
  // Mapping of ChessPieceType to a one-letter notation
  Map<ChessPieceType, String> typeNotation = {
    ChessPieceType.pawn: 'p',
    ChessPieceType.rook: 'r',
    ChessPieceType.knight: 'n',
    ChessPieceType.bishop: 'b',
    ChessPieceType.queen: 'q',
    ChessPieceType.king: 'k',
  };

  // Get the one-letter notation for the given type
  String notation = typeNotation[type] ?? '';

  // Determine the color suffix
  String colorSuffix = isWhite ? 'w' : 'b';

  // Construct and return the image path
  return 'lib/images/$notation$colorSuffix.jpg';
}


// Helper method to get a display name for a piece type
String getNameForPieceType(ChessPieceType type) {
  switch (type) {
    case ChessPieceType.queen:
      return 'Queen';
    case ChessPieceType.rook:
      return 'Rook';
    case ChessPieceType.bishop:
      return 'Bishop';
    case ChessPieceType.knight:
      return 'Knight';
    default:
      return '';
  }
}