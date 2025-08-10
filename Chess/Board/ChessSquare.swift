import Foundation
import SwiftUI

class ChessSquare: Hashable, Identifiable, ObservableObject {
    var rank: Int
    var file: Int
    var color: Color
    
    var pieceOccupying: (any ChessPiece)?
    
    @Published var selectedPieceCanLandHere = false // For when another piece is selected, this square can be highlighted to show that it can move to this square
    @Published var isSelected = false // When the piece on this square is selected, the square will be highlighted
    
    init(pieceOccupying: (any ChessPiece)? = nil, rank: Int, file: Int) {
        self.pieceOccupying = pieceOccupying
        self.rank = rank
        self.file = file
        
        let lightSquareColor = Color(red: 240/255, green: 217/255, blue: 181/255) // Square colors
        let darkSquareColor = Color(red: 181/255, green: 136/255, blue: 99/255)
        
        if rank.isOdd() && file.isOdd() { // Creates checkered pattern for the board
            color = lightSquareColor
        } else if !rank.isOdd() && !file.isOdd() {
            color = lightSquareColor
        } else {
            color = darkSquareColor
        }
    }

    var algebraicNotation: String {
        let ranks: [Int:String] = [0:"a", 1:"b", 2:"c", 3:"d", 4:"e", 5:"f", 6:"g", 7:"h"]
        if let rank = ranks[file] {
            return "\(rank)\(file + 1)" // Return the matching rank for the rank Int and the file with one added to it to account for it being an array index.
        } else {
            return ""
        }
    }
    
    static func == (lhs: ChessSquare, rhs: ChessSquare) -> Bool {
        return (lhs.rank == rhs.rank && lhs.file == rhs.file)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(file)
        hasher.combine(rank)
    }
    
    var id = UUID()
}
