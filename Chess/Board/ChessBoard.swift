import Foundation
import SwiftUI

class ChessBoard: ObservableObject {
    @Published var boardMatrix: [[ChessSquare]] = [
        [ChessSquare(pieceOccupying: Rook(location: (0, 0), isWhite: false), rank: 0, file: 0), ChessSquare(pieceOccupying: Knight(location: (0, 1), isWhite: false), rank: 0, file: 1), ChessSquare(pieceOccupying: Bishop(location: (0, 2), isWhite: false), rank: 0, file: 2), ChessSquare(pieceOccupying: Queen(location: (0, 3), isWhite: false), rank: 0, file: 3), ChessSquare(pieceOccupying: King(location: (0, 4), isWhite: false), rank: 0, file: 4), ChessSquare(pieceOccupying: Bishop(location: (0, 5), isWhite: false), rank: 0, file: 5), ChessSquare(pieceOccupying: Knight(location: (0, 6), isWhite: false), rank: 0, file: 6), ChessSquare(pieceOccupying: Rook(location: (0, 7), isWhite: false), rank: 0, file: 7)],
        [ChessSquare(pieceOccupying: Pawn(location: (1, 0), isWhite: false), rank: 1, file: 0), ChessSquare(pieceOccupying: Pawn(location: (1, 1), isWhite: false), rank: 1, file: 1), ChessSquare(pieceOccupying: Pawn(location: (1, 2), isWhite: false), rank: 1, file: 2), ChessSquare(pieceOccupying: Pawn(location: (1, 3), isWhite: false), rank: 1, file: 3), ChessSquare(pieceOccupying: Pawn(location: (1, 4), isWhite: false), rank: 1, file: 4), ChessSquare(pieceOccupying: Pawn(location: (1, 5), isWhite: false), rank: 1, file: 5), ChessSquare(pieceOccupying: Pawn(location: (1, 6), isWhite: false), rank: 1, file: 6), ChessSquare(pieceOccupying: Pawn(location: (1, 7), isWhite: false), rank: 1, file: 7)],
        [ChessSquare(rank: 2, file: 0), ChessSquare(rank: 2, file: 1), ChessSquare(rank: 2, file: 2), ChessSquare(rank: 2, file: 3), ChessSquare(rank: 2, file: 4), ChessSquare(rank: 2, file: 5), ChessSquare(rank: 2, file: 6), ChessSquare(rank: 2, file: 7)],
        [ChessSquare(rank: 3, file: 0), ChessSquare(rank: 3, file: 1), ChessSquare(rank: 3, file: 2), ChessSquare(rank: 3, file: 3), ChessSquare(rank: 3, file: 4), ChessSquare(rank: 3, file: 5), ChessSquare(rank: 3, file: 6), ChessSquare(rank: 3, file: 7)],
        [ChessSquare(rank: 4, file: 0), ChessSquare(rank: 4, file: 1), ChessSquare(rank: 4, file: 2), ChessSquare(rank: 4, file: 3), ChessSquare(rank: 4, file: 4), ChessSquare(rank: 4, file: 5), ChessSquare(rank: 4, file: 6), ChessSquare(rank: 4, file: 7)],
        [ChessSquare(rank: 5, file: 0), ChessSquare(rank: 5, file: 1), ChessSquare(rank: 5, file: 2), ChessSquare(rank: 5, file: 3), ChessSquare(rank: 5, file: 4), ChessSquare(rank: 5, file: 5), ChessSquare(rank: 5, file: 6), ChessSquare(rank: 5, file: 7)],
        [ChessSquare(pieceOccupying: Pawn(location: (6, 0), isWhite: true), rank: 6, file: 0), ChessSquare(pieceOccupying: Pawn(location: (6, 1), isWhite: true), rank: 6, file: 1), ChessSquare(pieceOccupying: Pawn(location: (6, 2), isWhite: true), rank: 6, file: 2), ChessSquare(pieceOccupying: Pawn(location: (6, 3), isWhite: true), rank: 6, file: 3), ChessSquare(pieceOccupying: Pawn(location: (6, 4), isWhite: true), rank: 6, file: 4), ChessSquare(pieceOccupying: Pawn(location: (6, 5), isWhite: true), rank: 6, file: 5), ChessSquare(pieceOccupying: Pawn(location: (6, 6), isWhite: true), rank: 6, file: 6), ChessSquare(pieceOccupying: Pawn(location: (6, 7), isWhite: true), rank: 6, file: 7)],
        [ChessSquare(pieceOccupying: Rook(location: (7, 0), isWhite: true), rank: 7, file: 0), ChessSquare(pieceOccupying: Knight(location: (7, 1), isWhite: true), rank: 7, file: 1), ChessSquare(pieceOccupying: Bishop(location: (7, 2), isWhite: true), rank: 7, file: 2), ChessSquare(pieceOccupying: Queen(location: (7, 3), isWhite: true), rank: 7, file: 3), ChessSquare(pieceOccupying: King(location: (7, 4), isWhite: true), rank: 7, file: 4), ChessSquare(pieceOccupying: Bishop(location: (7, 5), isWhite: true), rank: 7, file: 5), ChessSquare(pieceOccupying: Knight(location: (7, 6), isWhite: true), rank: 7, file: 6), ChessSquare(pieceOccupying: Rook(location: (7, 7), isWhite: true), rank: 7, file: 7)]
    ] // Starting chess position
    
    @Published var selectedSquare: ChessSquare? = nil
    
    var whiteIsInCheck: Bool {
        determineIfInCheck(kingLocation: findKing(isWhite: true), kingIsWhite: true)
    }
    
    var blackIsInCheck: Bool {
        determineIfInCheck(kingLocation: findKing(isWhite: false), kingIsWhite: false)
    }
    
    func makeMove(_ move: Move) {
        var moveData = move // Create a mutable copy of the move data
        handlePromotion(move: &moveData) // Check if a promotion needs to occur
        var updatedPiece = moveData.piece
        updatedPiece.location = move.endingSquare // Update piece location
        if move.isCastlingMove.0 { // If this move is a castle
            if move.isCastlingMove.1 { // If it is a kingside castle
                boardMatrix[move.endingSquare.0][move.endingSquare.1-1].pieceOccupying = boardMatrix[move.endingSquare.0][move.endingSquare.1+1].pieceOccupying // Move the rook
                boardMatrix[move.endingSquare.0][move.endingSquare.1].pieceOccupying = updatedPiece // Move the king
            } else {
                
            }
        }
        boardMatrix[move.endingSquare.0][move.endingSquare.1].pieceOccupying = updatedPiece // Update the piece on that square
        boardMatrix[move.startingSquare.0][move.startingSquare.1].pieceOccupying = nil // Set old square's piece to nil
    }
    func undoMove(_ move: Move, oldSquareContents: (any ChessPiece)?) {
        var updatedPiece = move.piece
        updatedPiece.location = move.startingSquare // Update piece location
        
        boardMatrix[move.startingSquare.0][move.startingSquare.1].pieceOccupying = updatedPiece // Bring the piece back to its old square
        boardMatrix[move.endingSquare.0][move.endingSquare.1].pieceOccupying = oldSquareContents // Set the square that it had moved to to its old contents (a piece or empty)
    }
    
    func findOpenSquares(forWhite: Bool) -> [(Int, Int)] {
        var openSquares: [(Int, Int)] = []
        for file in 0..<8 {
            for rank in 0..<8 {
                if let piece = boardMatrix[rank][file].pieceOccupying {
                    if forWhite ? !piece.isWhite : piece.isWhite {
                        openSquares.append((rank, file)) // If there is a piece of the opposite color on this square, add it to the list
                    }
                } else {
                    openSquares.append((rank, file)) // If there is no piece at all on this square, add it to the list
                }
            }
        }
        return openSquares
    }
    
    func isSquareEmpty(squareLocation: (Int, Int)) -> Bool {
        if squareLocation.0 > 7 || squareLocation.0 < 0 || squareLocation.1 > 7 || squareLocation.1 < 0 { return false } // Return false if the square is not on the board
        if boardMatrix[squareLocation.0][squareLocation.1].pieceOccupying == nil { // If there is no piece on the square
            return true
        } else {
            return false
        }
    }
    
    func findSelectedPiece() -> (any ChessPiece)? {
        for file in boardMatrix {
            for square in file {
                if square.isSelected {
                    if let piece = square.pieceOccupying { // Return the piece that is on the selected square
                        return piece
                    }
                }
            }
        }
        return nil // If there is no square with a selected piece, return nil
    }
    
    func highlightMoves(_ moves: [Move]) {
        moves.forEach { boardMatrix[$0.endingSquare.0][$0.endingSquare.1].selectedPieceCanLandHere = true } // Highlight all the squares that are given
    }
    
    func deselectAllSquares() {
        boardMatrix.forEach { file in file.forEach { square in
            square.isSelected = false
            square.selectedPieceCanLandHere = false
        }}
    }
    
    func selectPiece(_ square: ChessSquare, whiteToMove: Bool) {
        if let piece = square.pieceOccupying { // If there is a piece on the square
            if whiteToMove && piece.isWhite { // If white is to move and a white piece is tapped on
                square.isSelected = true
                var moves = piece.findPossibleMoves(on: self)
                moves.filterChecks(on: self) // Filter out the moves that put the white king in check
                highlightMoves(moves) // Select that piece and highlight its squares
            } else if !whiteToMove && !piece.isWhite { // If black is to move and a black piece is tapped on
                square.isSelected = true
                var moves = piece.findPossibleMoves(on: self)
                moves.filterChecks(on: self) // Filter out the moves that put the black king in check
                highlightMoves(moves) // Select that piece and highlight its squares
            }
        }
    }
    
    func findKing(isWhite: Bool) -> (Int, Int) {
        var result = (10, 10) // Random default value because there will always be a king on the board
        boardMatrix.forEach { file in file.forEach { square in
            if let piece = square.pieceOccupying {
                if piece.name == "King" && (isWhite ? piece.isWhite: !piece.isWhite) { result = piece.location } // Set result to the location of the specified king
            }
        }}
        return result
    }
    
    func determineIfInCheck(kingLocation: (Int, Int), kingIsWhite: Bool) -> Bool {
        var result = false
        boardMatrix.forEach { file in file.forEach { square in
            if let piece = square.pieceOccupying { // For each piece on the board
                if kingIsWhite && !piece.isWhite { // If the king is white and the piece is black
                    piece.findPossibleMoves(on: self).forEach { move in
                        if move.endingSquare == kingLocation { result = true } // The white king is in check if a black piece can capture it on its next move
                    }
                } else if !kingIsWhite && piece.isWhite { // If the king is black and the piece is white
                    piece.findPossibleMoves(on: self).forEach { move in
                        if move.endingSquare == kingLocation { result = true } // The black king is in check if a white piece can capture it on its next move
                    }
                }
            }
        }}
        return result
    }
    func handlePromotion(move: inout Move) {
        guard move.piece.name == "Pawn" else { return } // If the piece is not a pawn it obviously cannot promote
        let isPromotionRow = move.piece.isWhite ? move.endingSquare.0 == 0 : move.endingSquare.0 == 7 // If the pawn is moving to the opposing back rank
        if isPromotionRow {
            move.piece = Queen(location: move.endingSquare, isWhite: move.piece.isWhite) // Promote it to a queen
        }
    }
}
