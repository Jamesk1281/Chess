import Foundation
import SwiftUI

struct Bishop: ChessPiece {
    var name = "Bishop"
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
        self.image = isWhite ? Image("WhiteBishop") : Image("BlackBishop")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] {
        var moves: [Move] = []
        
        var x = location.0
        var y = location.1
        while x < 8 && y < 8 {
            let result = checkMove(to: (x, y), board: board) // Checks for moves on the diagonal above and to the right of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
            x++
            y++
        }
        x = location.0 // Reset temporary looping variables
        y = location.1
        while x > -1 && y < 8 {
            let result = checkMove(to: (x, y), board: board) // Checks for moves on the diagonal above and to the left of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
            x--
            y++
        }
        x = location.0 // Reset temporary looping variables
        y = location.1
        while x < 8 && y > -1 {
            let result = checkMove(to: (x, y), board: board) // Checks for moves on the diagonal below and to the right of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
            x++
            y--
        }
        x = location.0 // Reset temporary looping variables
        y = location.1
        while x > -1 && y > -1 {
            let result = checkMove(to: (x, y), board: board) // Checks for moves on the diagonal below and to the left of the piece
            if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) } // Adds move if it has been validated
            if !result.1 { break } // Start checking next direction if there is a piece in the way
            x--
            y--
        }
        return moves
    }
    
    var FENIdentifier: String {
        return isWhite ? "B" : "b"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: Bishop, rhs: Bishop) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
