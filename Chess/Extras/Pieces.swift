import Foundation
import SwiftUI

extension [Move] {
    // MARK: Used to filter out moves that will put the piece's own king in check
    mutating func filterChecks(on board: ChessBoard) {
        self.forEach { move in // For each move
            let oldSquareContents = board.boardMatrix[move.endingSquare.0][move.endingSquare.1].pieceOccupying // Save the square the piece is moving to's old content
            board.makeMove(move) // Temporarily make the move
            if move.piece.isWhite {
                if board.whiteIsInCheck { // If the this move is by white and ends with the white king in check
                    self.removeAll(where: { $0 == move }) // Remove it because it's illegal
                }
            } else {
                if board.blackIsInCheck { // If the this move is by black and ends with the black king in check
                    self.removeAll(where: { $0 == move }) // Remove it because it's illegal
                }
            }
            board.undoMove(move, oldSquareContents: oldSquareContents) // Revert the board to its original state
        }
    }
}
