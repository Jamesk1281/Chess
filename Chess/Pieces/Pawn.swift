import Foundation
import SwiftUI

struct Pawn: ChessPiece {
    var name = "Pawn"
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
        self.image = isWhite ? Image("WhitePawn") : Image("BlackPawn")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] { // FIXME: Add En Passant functionality
        var moves: [Move] = []
        
        func getSquare(at squareLocation: (Int, Int)) -> ChessSquare? { // Safely access ChessSquares without the risk of indexing out of bounds
            if squareLocation.0 > 7 || squareLocation.0 < 0 || squareLocation.1 > 7 || squareLocation.1 < 0 { // Verify that the square is on the board
                return nil
            } else {
                return board.boardMatrix[squareLocation.0][squareLocation.1]
            }
        }
        
        let direction = isWhite ? -1 : 1 // If the pawn is white, it will be moving UP the board. If it's black it will be moving DOWN the board
        if getSquare(at: (location.0+direction, location.1))?.pieceOccupying == nil { // Check the directly square ahead of the pawn
            moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0 + direction, location.1)))
        }
        if !hasMoved && getSquare(at: (location.0+2*direction, location.1))?.pieceOccupying == nil && !moves.isEmpty { // Check the square one and two squares ahead of the pawn if it hasn't moved
            moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0 + 2 * direction, location.1)))
        }
        if getSquare(at: (location.0 + direction, location.1-1))?.pieceOccupying?.isWhite == !isWhite { // Check if it can capture diagonally left
            moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0 + direction, location.1 - 1)))
        }
        if getSquare(at: (location.0 + direction, location.1+1))?.pieceOccupying?.isWhite == !isWhite { // Check if it can capture diagonally right
            moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0 + direction, location.1 + 1)))
        }
        return moves
    }
    
    var FENIdentifier: String {
        return isWhite ? "P" : "p"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: Pawn, rhs: Pawn) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

