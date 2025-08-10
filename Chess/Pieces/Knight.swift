import Foundation
import SwiftUI

struct Knight: ChessPiece {
    var name = "Knight"
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
        self.image = isWhite ? Image("WhiteKnight") : Image("BlackKnight")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] {
        var moves: [Move] = []
        func checkAndAddIfTrue(squareLocation: (Int, Int)) { // Helper function that uses checkMove func and adds to moves array if the move is validated
            if checkMove(to: squareLocation, board: board).0 {
                moves.append(Move(piece: self, startingSquare: location, endingSquare: squareLocation))
            }
        }
        checkAndAddIfTrue(squareLocation: (location.0-2, location.1-1))
        checkAndAddIfTrue(squareLocation: (location.0-2, location.1+1))
        checkAndAddIfTrue(squareLocation: (location.0-1, location.1+2))
        checkAndAddIfTrue(squareLocation: (location.0+1, location.1+2))
        checkAndAddIfTrue(squareLocation: (location.0+2, location.1+1))
        checkAndAddIfTrue(squareLocation: (location.0+2, location.1-1))
        checkAndAddIfTrue(squareLocation: (location.0+1, location.1-2))
        checkAndAddIfTrue(squareLocation: (location.0-1, location.1-2))
        return moves
    }
    
    var FENIdentifier: String {
        return isWhite ? "N" : "n"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: Knight, rhs: Knight) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
