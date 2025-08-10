import Foundation
import SwiftUI

struct Queen: ChessPiece {
    var name = "Queen"
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
        self.image = isWhite ? Image("WhiteQueen") : Image("BlackQueen")
    }
    
    func findPossibleMoves(on board: ChessBoard) -> [Move] {
            var moves: [Move] = []
            
            // Reuse Rook-like moves (horizontal/vertical)
            moves.append(contentsOf: findRookMoves(on: board))
            
            // Reuse Bishop-like moves (diagonal)
            moves.append(contentsOf: findBishopMoves(on: board))
            
            return moves
    }
        
        private func findRookMoves(on board: ChessBoard) -> [Move] { // Redefine findPossibleMoves for the rook component of a queen's moves
            var moves: [Move] = []
            
            for rankIndex in (location.0)...7 {
                let result = checkMove(to: (rankIndex, location.1), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (rankIndex, location.1))) }
                if !result.1 { break }
            }
            for rankIndex in (0...(location.0)).reversed() {
                let result = checkMove(to: (rankIndex, location.1), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (rankIndex, location.1))) }
                if !result.1 { break }
            }
            for fileIndex in (location.1)...7 {
                let result = checkMove(to: (location.0, fileIndex), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0, fileIndex))) }
                if !result.1 { break }
            }
            for fileIndex in (0...(location.1)).reversed() {
                let result = checkMove(to: (location.0, fileIndex), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (location.0, fileIndex))) }
                if !result.1 { break }
            }
            return moves
        }
        
        private func findBishopMoves(on board: ChessBoard) -> [Move] { // Redefine findPossibleMoves for the bishop component of a queen's moves
            var moves: [Move] = []
            
            var x = location.0
            var y = location.1
            while x < 7 && y < 7 {
                x += 1
                y += 1
                let result = checkMove(to: (x, y), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) }
                if !result.1 { break }
            }
            
            x = location.0
            y = location.1
            while x > 0 && y < 7 {
                x -= 1
                y += 1
                let result = checkMove(to: (x, y), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) }
                if !result.1 { break }
            }
            
            x = location.0
            y = location.1
            while x < 7 && y > 0 {
                x += 1
                y -= 1
                let result = checkMove(to: (x, y), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) }
                if !result.1 { break }
            }
            
            x = location.0
            y = location.1
            while x > 0 && y > 0 {
                x -= 1
                y -= 1
                let result = checkMove(to: (x, y), board: board)
                if result.0 { moves.append(Move(piece: self, startingSquare: location, endingSquare: (x, y))) }
                if !result.1 { break }
            }
            
            return moves
        }
    
    var FENIdentifier: String {
        return isWhite ? "Q" : "q"
    }
    
    var debugDescription: String { "\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1)))" }
    var id = UUID()
    
    // Conformances
    static func == (lhs: Queen, rhs: Queen) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

