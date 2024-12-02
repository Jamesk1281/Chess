//
//  UsefulThings.swift
//  ChessML
//
//  Created by James . on 9/30/24.
//

import Foundation

/* Sample board

convertToFEN([
     [nil, Knight(location: (0,1), isWhite: false), Bishop(location: (0,2), isWhite: false), Queen(location: (0,3), isWhite: false), King(location: (0,4), isWhite: false), Bishop(location: (0,5), isWhite: false), Knight(location: (0,6), isWhite: false), Rook(location: (0,7), isWhite: false)],
     [Rook(location: (1,0), isWhite: false), Pawn(location: (1,1), isWhite: false), Pawn(location: (1,2), isWhite: false), nil, Pawn(location: (1,4), isWhite: false), Pawn(location: (1,5), isWhite: false), Pawn(location: (1,6), isWhite: false), Pawn(location: (1,7), isWhite: false)],
     [Pawn(location: (2,0), isWhite: false), nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, Pawn(location: (3,3), isWhite: false), Pawn(location: (3,4), isWhite: true), nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil, nil],
     [nil, nil, nil, nil, nil, nil, nil, Pawn(location: (5, 7), isWhite: true)],
     [Pawn(location: (6,0), isWhite: true), Pawn(location: (6,1), isWhite: true), Pawn(location: (6,2), isWhite: true), Pawn(location: (6,3), isWhite: true), nil, Pawn(location: (6,5), isWhite: true), Pawn(location: (6,6), isWhite: true), nil],
     [Rook(location: (7,0), isWhite: true), Knight(location: (7,1), isWhite: true), Bishop(location: (7,2), isWhite: true), Queen(location: (7,3), isWhite: true), King(location: (7,4), isWhite: true), Bishop(location: (7,5), isWhite: true), Knight(location: (7,6), isWhite: true), Rook(location: (7,7), isWhite: true)]
     ], game: ChessGame(move: Move(piece: Pawn(location: (3,3), isWhite: false), startingSquare: (1,3), endingSquare: (3,3))))
 
*/

func convertToAlgebraicNotation(square: (Int, Int)) -> String {
    let ranks: [Int:String] = [0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h"]
    if let rank = ranks[square.0] {
        return "\(rank)\(8 - square.1 + 1)" // Return the matching rank character for the rank Int and the file with one added to it to account for it being an array index and subtracted from 8 to account for the board being inverted.
    } else {
        return ""
    }
}

//struct Square { // MARK: Maybe make the boardmatrix out of squares with pieces inside of them
//    var pieceOccupying: (any ChessPiece)?
//    var rank: Int
//    var file: Int
//
//    var algebraicNotation: String {
//        let ranks: [Int:String] = [0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h"]
//        if let rank = ranks[file] {
//            return "\(rank)\(file + 1)" // Return the matching rank for the rank Int and the file with one added to it to account for it being an array index.
//        } else {
//            return ""
//        }
//    }
//}
