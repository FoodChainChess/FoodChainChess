//
//  StartGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI
import DouShouQiModel

struct StartGamePopUpView: View {
    @EnvironmentObject var playerManager: PlayerManager
        
    @State private var selectedGameMode: String = "pvp"
    @State private var selectedPlayer1: String = "no player selected"
    @State private var selectedPlayer2: String = "no player selected"
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                // Game mode selection
                Picker(NSLocalizedString("Game Mode", tableName: "Localization", comment: ""),
                       selection: $selectedGameMode) {
                    
                    Text("PvP", tableName: "Localization")
                        .tag("pvp")
                    
                    Text("Player vs Computer", tableName: "Localization")
                        .tag("pve")
                    
                    Text("Multi-Device", tableName: "Localization")
                        .tag("multi")
                }
                .pickerStyle(.navigationLink)
                
                // Player Selection
                Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 1",
                       selection: $selectedPlayer1) {
                    
                    // need to use count because player does not conform with identifiable
                    ForEach(0..<playerManager.createdPlayers.count, id: \.self) { index in
                        Text(playerManager.createdPlayers[index].name)
                            .tag(playerManager.createdPlayers[index].name)
                    }
                }
                       .pickerStyle(.navigationLink)
                
                Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 2",
                       selection: $selectedPlayer2) {
                    
                    ForEach(0..<playerManager.createdPlayers.count, id: \.self) { index in
                        Text(playerManager.createdPlayers[index].name)
                            .tag(playerManager.createdPlayers[index].name)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            MainButtonView(
                buttonText: NSLocalizedString("Play", tableName: "Localization", comment: ""),
                color: Colors.text,
                iconName: "play.fill",
                textColor: Color("Background"),
                destination: AnyView(BoardView(player1: PlayerVM(player: HumanPlayer(withName: "Lou", andId: .player1)!), player2: PlayerVM(player: RandomPlayer(withName: "LouBis", andId: .player2)!)).navigationBarBackButtonHidden(true))
            ).padding()
            .navigationTitle(NSLocalizedString("New Game", tableName: "Localization", comment: ""))
        }
    }
}

struct StartGamePopUpView_Previews: PreviewProvider {
    @State static var isShowing = true
    
    static var previews: some View {
        let playerManager = PlayerManager()
        playerManager.addPlayer(username: "LouSusQi")
        playerManager.addPlayer(username: "LouSusQuoi")
        playerManager.addPlayer(username: "LouSusÇa")
        playerManager.addPlayer(username: "LouSusComment")
        
        return StartGamePopUpView()
            .environmentObject(playerManager)
    }
}

