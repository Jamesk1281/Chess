import Foundation
import SwiftUI

struct King: ChessPiece {
    var name = "King"
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
        self.image = isWhite ? Image("WhiteKing") : Image("BlackKing")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] {
        var moves: [Move] = []
        func checkAndAddIfTrue(squareLocation: (Int, Int)) { // Helper function that uses checkMove func and adds to moves array if the move is validated
            if checkMove(to: squareLocation, board: board).0 {
                moves.append(Move(piece: self, startingSquare: location, endingSquare: squareLocation))
            }
        }
        
        checkAndAddIfTrue(squareLocation: (location.0-1, location.1-1)) // Check square above and left
        checkAndAddIfTrue(squareLocation: (location.0-1, location.1)) // Above
        checkAndAddIfTrue(squareLocation: (location.0-1, location.1+1)) // Above and right
        checkAndAddIfTrue(squareLocation: (location.0, location.1-1)) // Left
        checkAndAddIfTrue(squareLocation: (location.0, location.1+1)) // Right
        checkAndAddIfTrue(squareLocation: (location.0+1, location.1-1)) // Below and left
        checkAndAddIfTrue(squareLocation: (location.0+1, location.1)) // Below
        checkAndAddIfTrue(squareLocation: (location.0+1, location.1+1)) // Below and right
        
        if !hasMoved {
            checkCastling(kingSide: true)
            checkCastling(kingSide: false)
        }
        
        func checkCastling(kingSide: Bool) { // FIXME: this doesnt work
            if kingSide {
                guard let rook = board.boardMatrix[location.0][location.1+3].pieceOccupying else { return } // Find the piece on the rook's starting square
                if rook.name == "Rook" && rook.isWhite == isWhite && !rook.hasMoved { // If the piece is a rook of the same color as the king and has not moved
                    let squareOneRight = (location.0, location.1 + 1)
                    let squareTwoRight = (location.0, location.1 + 2)
                    print("found rook")
                    if board.isSquareEmpty(squareLocation: squareOneRight) && board.isSquareEmpty(squareLocation: squareTwoRight) {  // If both squares next to the king are empty
                        print("squares are empty")
                        if board.determineIfInCheck(kingLocation: squareOneRight, kingIsWhite: isWhite) && board.determineIfInCheck(kingLocation: squareTwoRight, kingIsWhite: isWhite) {  // If neither of the squares the king needs to pass over would put the king in check
                            print("not in check")
                            moves.append(Move(piece: self, startingSquare: (location), endingSquare: squareTwoRight, isCastlingMove: (true, true))) // Add the kingside castling move to the list
                        }
                    }
                }
            }
        }
        return moves
    }
    
    var FENIdentifier: String {
        return isWhite ? "K" : "k"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: King, rhs: King) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
