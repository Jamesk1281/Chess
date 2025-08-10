import Foundation
import SwiftUI

protocol ChessPiece: Identifiable, Hashable {
    var name: String { get }
    var isWhite: Bool { get }
    var location: (Int, Int) { get set } // Both files and ranks are ints, and individual squares are referred to using (rank, file). Also, ranks are inverted, so the top is the first and the bottom is the last
    var FENIdentifier: String { get } // Used for identifying pieces as either uppercase (white) or lowercase (black) for FEN records
    var hasMoved: Bool { get set } // Must start as false
    var image: Image { get }
    var id: UUID { get } // Must be UUID()
    var debugDescription: String { get } // Should be "\n\(isWhite ? "White" : "Black") \(name), Location: (\(String(location.0)), \(String(location.1))"
    init(location: (Int, Int), isWhite: Bool)
    
    func findPossibleMoves(on board: ChessBoard) -> [Move]
}

extension ChessPiece {
    // MARK: checkMove method works for pieces that can move to a square that is empty or has an opposing color piece on it (all generic chess pieces but pawn)
    func checkMove(to squareLocation: (Int, Int), board: ChessBoard) -> (Bool, Bool) { // First Bool: If the move is valid or not. Second Bool (for pieces that move in a line): Returns whether or not to keep checking down that line
        if squareLocation.0 > 7 || squareLocation.0 < 0 || squareLocation.1 > 7 || squareLocation.1 < 0 { // Verify that the square is on the board
            return (false, false)
        }
        if !(board.boardMatrix[squareLocation.0][squareLocation.1].pieceOccupying?.id == self.id) { // If the square doesn't have this piece on it
            if let pieceOnSquare = board.boardMatrix[squareLocation.0][squareLocation.1].pieceOccupying { // If the square has a piece on it
                if (isWhite ? pieceOnSquare.isWhite : !pieceOnSquare.isWhite) { return (false, false) } else { // If the piece is white, move onto the next direction. If it's black, validate that move and move onto the next direction
                    return (true, false)
                }
            } else {
                return (true, true) // If the square is empty, validate the move and keep going
            }
        }
        return (false, true) // If this square has the piece being checked on it, invalidate the move and keep going
    }
}
