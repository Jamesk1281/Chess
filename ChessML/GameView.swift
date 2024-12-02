//
//  ContentView.swift
//  ChessML
//
//  Created by James . on 9/23/24.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var game: ChessGame
    
    var body: some View {
        ChessBoardView(board: game.board, game: game)
    }
}



#Preview {
    GameView(game: ChessGame())
}


