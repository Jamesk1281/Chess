import Foundation
import SwiftUI

func evaluateFEN(fen: String, depth: Int) -> String {
    let task = Process()
    let inputPipe = Pipe()   // Pipe for sending commands to the process
    let outputPipe = Pipe()  // Pipe for receiving the process output
    
    let commands = ["position fen \(fen)", "eval"]               // MARK: ADJUST DEPTH HERE

    task.standardOutput = outputPipe
    task.standardError = outputPipe
    task.standardInput = inputPipe
    task.arguments = ["-c", "stockfish"]
    task.launchPath = "/bin/zsh"
    
    task.environment = ["PATH": "/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"]

    var results = ""

    // Buffer to accumulate output
    var outputBuffer = ""

    // Set a handler to read output incrementally as it becomes available
    outputPipe.fileHandleForReading.readabilityHandler = { fileHandle in
        let outputData = fileHandle.availableData
        if let output = String(data: outputData, encoding: .utf8), !output.isEmpty {
            outputBuffer += output
        }
    }

    do {
        try task.run()  // Launch the stockfish process
    } catch {
        print("Error: \(error.localizedDescription)")
        return "Error: \(error.localizedDescription)"
    }

    // Helper function to wait for a specific response from Stockfish
    func waitForOutput(output: String) {
        // Keep checking the buffer until the expected output is found
        while !outputBuffer.contains(output) {
            usleep(100_000)  // Wait for 0.1 seconds and check again
        }
    }

    // Send each command and wait for a specific response
    for command in commands {
        if let commandData = "\(command)\n".data(using: .utf8) {
            inputPipe.fileHandleForWriting.write(commandData)  // Write command to input
        }
        // Wait for the expected output to indicate the command has completed
        if command == "eval" {
            waitForOutput(output: "Final evaluation")
            results.append(outputBuffer)
        }
    }

    // Close the process input and stop reading
    inputPipe.fileHandleForWriting.closeFile()
    outputPipe.fileHandleForReading.readabilityHandler = nil
    task.terminate() // Terminate the process
    
    let words = results.split(separator: " ", omittingEmptySubsequences: true)
    var eval = ""
    for (index, word) in words.enumerated() {
        if word == "evaluation" {
            eval = String(words[index+1])
        }
    }
    return eval
}

func convertToFEN(_ board: [[(any ChessPiece)?]], game: ChessGame) -> String {
    var FEN = ""
    
    for rank in board { // Handles the piece placement section of a FEN record.
        var emptySquareStreak = 0
        var currentPPLine = ""
        
        for square in rank {
            if square == nil {
                emptySquareStreak += 1
            } else {
                if emptySquareStreak != 0 {
                    currentPPLine += String(emptySquareStreak)
                    emptySquareStreak = 0
                }
                currentPPLine += square?.FENIdentifier ?? "P"
            }
        }
        if emptySquareStreak != 0 {
            currentPPLine += String(emptySquareStreak)
        }
        emptySquareStreak = 0
        FEN += currentPPLine; FEN += "/"
    }
    FEN.removeLast() // Removes extra backslash at the end.
    FEN += (game.whiteToMove ? " w " : " b ") // Handles the active color section.
    
    var canCastleString = "" // Handles the castling ability section.
    var blackKingHasNotMoved = false
    var whiteKingHasNotMoved = false
    var blackQueensideRookHasNotMoved = false
    var blackKingsideRookHasNotMoved = false
    var whiteQueensideRookHasNotMoved = false
    var whiteKingsideRookHasNotMoved = false
    for (rankIndex, rank) in board.enumerated() {
        for (squareIndex, _) in rank.enumerated() { // Check if certain pieces have moved from their original location.
            if let square = board[rankIndex][squareIndex] {
                if square.name == "King" && !square.isWhite && square.location == (0,4) { blackKingHasNotMoved = true } // black king
                else if square.name == "King" && square.isWhite && square.location == (7,4) { whiteKingHasNotMoved = true } // white king
                else if square.name == "Rook" && !square.isWhite && square.location == (0,0) { blackQueensideRookHasNotMoved = true } // black queenside rook
                else if square.name == "Rook" && !square.isWhite && square.location == (0,7) { blackKingsideRookHasNotMoved = true } // black kingside rook
                else if square.name == "Rook" && square.isWhite && square.location == (7,0) { whiteQueensideRookHasNotMoved = true } // white queenside rook
                else if square.name == "Rook" && square.isWhite && square.location == (7,7) { whiteKingsideRookHasNotMoved = true } // white kingside rook
            }
        }
    }
    if whiteKingHasNotMoved {
        if whiteKingsideRookHasNotMoved { canCastleString += "K" }
        if whiteQueensideRookHasNotMoved { canCastleString += "Q" }
    }
    if blackKingHasNotMoved {
        if blackKingsideRookHasNotMoved { canCastleString += "k" }
        if blackQueensideRookHasNotMoved { canCastleString += "q" }
    }
    if canCastleString == "" { canCastleString = "- " } else { canCastleString += " " }
    FEN += canCastleString
    
    var enPassantSquare = "" // Handles the en passant target square section.
    if let move = game.mostRecentMove { // If a move has been made.
        if move.piece.name == "Pawn" && (move.startingSquare.0 - move.endingSquare.0) == 2 { // If the most recent move was made by a white pawn and it moved 2 squares foward.
            enPassantSquare = convertToAlgebraicNotation(square: (move.endingSquare.0, move.endingSquare.1))
        } else if move.piece.name == "Pawn" && (move.startingSquare.0 - move.endingSquare.0) == -2 {
            enPassantSquare = convertToAlgebraicNotation(square: (move.endingSquare.0, move.endingSquare.1)) // If the most recent move was made by a black pawn and it moved 2 squares foward.
        }
    }
    if enPassantSquare == "" { enPassantSquare = "- " } else { enPassantSquare += " " }
    FEN += enPassantSquare
    
    FEN += "\(String(game.halfMoveClock)) " // Handles the halfmove clock section.
    FEN += "\(String(game.fullMoveNumber))" // Handles the fullmove number section.
    print(FEN)
    return FEN
}
