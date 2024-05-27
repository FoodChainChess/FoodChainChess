import Foundation
import DouShouQiModel


func readInt(withMessage message: String) -> Int {
    var temp: Int?
    while temp == nil {
        print(message)
        let result = readLine()
        temp = Int(result ?? "")
    }
    return temp!
}

func readMove(from player: HumanPlayer) -> Move? {
    var originRow, originCol, destRow, destCol : Int?
    
    originRow = readInt(withMessage: "\(player.name) please enter the origin row in which your piece is)")
    originCol = readInt(withMessage: "\(player.name) please enter the origin column in which your piece is)")
    destRow = readInt(withMessage: "\(player.name) please enter the destination row in which you want to move your piece)")
    destCol = readInt(withMessage: "\(player.name) please enter the destination column in which you want to move your piece)")
    return Move(of: player.id, fromRow: originRow!, andFromColumn: originCol!, toRow: destRow!, andToColumn: destCol!)
}



@main
struct CLI {
    static func main() async throws {
        
        print("Would you like to:")
        print("1. Start a new game")
        print("2. Load the last saved game")
        
        var game: Game
        let choice = readLine()
        switch choice {
//        case "2":
//            game = try await Persistance.loadGame(withName: "game")!
        default:
            game = try Game(withRules: ClassicRules(), andPlayer1: HumanPlayer(withName: "Tom", andId: .player1, andInputMethod: readMove)!, andPlayer2: RandomPlayer(withName: "Jerry", andId: .player2)!)
        }
        for player in game.players {
            if player.value is HumanPlayer {
                let hp = player.value as! HumanPlayer
                hp.changeInput(input: readMove)
            }
        }
        
        game.addGameStartedListener {
            print($0)
            print("**************************************")
            print("     ==>> 🎉 GAME STARTS! 🎉 <<==     ")
            print("**************************************")
            //_ = readLine()
        }
        
        game.addPlayerNotifiedListener({ board, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), it's your turn!")
            print("**************************************")
            //try! await Persistance.saveGame(withName: "game", andGame: game2)
            _ = readLine()
            if player is HumanPlayer {
                var move = readMove(from: player as! HumanPlayer)
                try! await (player as! HumanPlayer).chooseMove(move)
            } else {
                _ = try! await player.chooseMove(in: board, with: game.rules)
            }
        })
        
//        game.addGameChangedListener({ game async in
//            try! await Persistance.saveGame(withName: "game.json", andGame: game)
//        })
        
        game.addMoveChosenCallbacksListener { _, move, player in
            print("**************************************")
            print("Player \(player.id == .player1 ? "🟡 1" : "🔴 2") - \(player.name), has chosen: \(move)")
            print("**************************************")
        }
        
        game.addInvalidMoveCallbacksListener { _, move, player, result in
            if result {
                return
            }
            print("**************************************")
            print("⚠️⚠️⚠️⚠️ Invalid Move detected: \(move) by \(player.name) (\(player.id))")
            print("**************************************")
            //_ = readLine()
        }
        
        game.addBoardChangedListener {
            print($0)
        }
        
        game.addGameOverListener { board, result, player in
            switch(result){
            case .notFinished:
                print("⏳ Game is not over yet!")
            case .winner(winner: let o, reason: let r):
                print(board)
                print("**************************************")
                print("Game Over!!!")
                print("🥇🏆 and the winner is... \(o == .player1 ? "🟡" : "🔴") \(player?.name ?? "")!")
                switch(r){
                case .denReached:
                    print("🪺 the opponent's den has been reached.")
                case .noMorePieces:
                    print("🐭🐱🐯🦁🐘 all the opponent's animals have been eaten...")
                case .noMovesLeft:
                    print("⛔️ the opponent can not move any piece!")
                case .tooManyOccurences:
                    print("🔄 the opponent seem to like this situation... but enough is enough. Sorry...")
                }
                print("**************************************")
            default:
                break
            }
        }
        
        try await game.start()
    }
}

