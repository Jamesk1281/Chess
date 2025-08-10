//
//  ChessMLApp.swift
//  ChessML
//
//  Created by James . on 9/23/24.
//

import SwiftUI

@main
struct ChessApp: App {
    @StateObject var game = ChessGame()
    
    var body: some Scene {
        WindowGroup {
            GameView(game: game)
        }
    }
}
