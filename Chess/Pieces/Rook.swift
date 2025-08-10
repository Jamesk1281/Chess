import Foundation
import SwiftUI

struct Rook: ChessPiece {
    var name = "Rook"
    var image: Image
    var location: (Int, Int) {
        didSet {
            hasMoved = true
        }
    }
    let isWhite: Bool
    var hasMoved = false
    
    init(location: (Int, Int), isWhite: Bool) {
        self.location = location
        self.isWhite = isWhite
        self.image = isWhite ? Image("WhiteRook") : Image("BlackRook")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] { // FIXME: REFACTOR
        var moves: [Move] = []
        
        for rankIndex in (location.0)...7 {
            let result = checkMove(to: (rankIndex, location.1), board: board) // Checks for moves above the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (rankIndex, location.1))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
        }
        for rankIndex in (0...(location.0)).reversed() {
            let result = checkMove(to: (rankIndex, location.1), board: board) // Checks for moves below the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (rankIndex, location.1))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
        }
        for fileIndex in (location.1)...7 {
            let result = checkMove(to: (location.0, fileIndex), board: board) // Checks for moves to the right of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0, fileIndex))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
        }
        for fileIndex in (0...(location.1)).reversed() {
            let result = checkMove(to: (location.0, fileIndex), board: board) // Checks for moves to the left of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0, fileIndex))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
        }
        return moves
    }
    
    var FENIdentifier: String {
        return isWhite ? "R" : "r"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: Rook, rhs: Rook) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
