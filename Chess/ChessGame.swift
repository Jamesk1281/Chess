import Foundation

class ChessGame: ObservableObject {
    @Published var board = ChessBoard()
    var whiteToMove = true
    
    var mostRecentMove: Move? = nil { // Handles half and full move numbers.
        willSet {
            if let move = newValue {
                if !move.piece.isWhite {
                    fullMoveNumber += 1
                    halfMoveClock += 1
                }
            }
        }
    }
    
    func makeMove(_ move: Move) {
        mostRecentMove = move
        board.makeMove(move)
        board.deselectAllSquares()
        whiteToMove.toggle()
    }
    
    var halfMoveClock = 0
    var fullMoveNumber = 1
}

struct Move: Equatable, CustomDebugStringConvertible {
    var piece: any ChessPiece
    
    var startingSquare: (Int, Int)
    var endingSquare: (Int, Int)
    
    var isCastlingMove: (Bool, Bool) = (false, false) // First bool is whether or not this is a castling move. Second bool regards the side: true means kingside, false means queenside
    
    var debugDescription: String {
        "\(piece.debugDescription) startingSquare: \(startingSquare) endingSquare: \(endingSquare), isCastlingMove: \(isCastlingMove)"
    }
    
    static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.piece.id == rhs.piece.id && lhs.startingSquare == rhs.startingSquare && lhs.endingSquare == rhs.endingSquare 
    }
}
