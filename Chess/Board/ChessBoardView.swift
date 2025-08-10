import Foundation
import SwiftUI

struct ChessBoardView: View {
    var game: ChessGame
    
    var body: some View {
        drawChessBoard(game: game)
    }

    func drawChessBoard(game: ChessGame) -> some View {
        return Grid { // Creates a grid of the 64 (8x8) ChessSquares
            ForEach(game.board.boardMatrix, id: \.self) { file in
                GridRow {
                    ForEach(file, id: \.self) { square in
                        SquareView(square: square)
                            .onTapGesture {
                                if let selectedPiece = game.board.findSelectedPiece() { // If a piece is selected
                                    if square.isSelected { // If this is the selected square
                                        game.board.deselectAllSquares() // Deselect it and restart
                                    } else if square.selectedPieceCanLandHere { // If this is a square that can be landed on
                                        game.makeMove(Move(piece: selectedPiece, startingSquare: selectedPiece.location, endingSquare: (square.rank, square.file))) // Move the selected piece to this square
                                    } else {
                                        game.board.deselectAllSquares()
                                        game.board.selectPiece(square, whiteToMove: game.whiteToMove)
                                    }
                                } else {
                                    game.board.selectPiece(square, whiteToMove: game.whiteToMove) // If no piece is selected, select this one
                                }
                            }
                    }
                }
            }
        }
    }
    
    struct SquareView: View {
        @ObservedObject var square: ChessSquare
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(square.isSelected ? .yellow : square.color)
                    .frame(width: 85, height: 85)
                square.pieceOccupying?.image // Place the piece's image on top of the square
                if square.selectedPieceCanLandHere {
                    Circle()
                        .fill(.gray)
                        .opacity(0.5)
                }
            }
        }
    }
}
