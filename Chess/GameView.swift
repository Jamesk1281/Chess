import SwiftUI

struct GameView: View {
    @ObservedObject var game: ChessGame
    
    var body: some View {
        ChessBoardView(game: game)
    }
}
