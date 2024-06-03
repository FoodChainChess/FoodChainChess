//
//  StartGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI
import DouShouQiModel

struct StartGamePopUpView: View {
    
    @State private var selectedGameMode: String = "PvP"
    @State private var selectedPlayerName1: String = "none"
    @State private var selectedPlayerName2: String = "none"
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                // Game mode selection
                Picker(NSLocalizedString("Game Mode", tableName: "Localization", comment: ""),
                       selection: $selectedGameMode) {
                    
                    Text("Player vs Player", tableName: "Localization")
                        .tag("pvp")
                    
                    Text("Player vs Computer", tableName: "Localization")
                        .tag("pve")
                    
                    Text("Multi-Device", tableName: "Localization")
                        .tag("multi")
                }
               .pickerStyle(.navigationLink)
                
                // Player Selection
                Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 1",
                       selection: $selectedPlayerName1) {
                    
                    Text("Ronaldo")
                        .tag("Roanldo")
                    
                    Text("Messi")
                        .tag("Messi")
                }
                
                Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 2",
                       selection: $selectedPlayerName2) {
                    
                    Text("Neymar")
                        .tag("Neymar")
                    
                    Text("Haaland")
                        .tag("Haaland")
                }
            }
            MainButtonView(
                buttonText: NSLocalizedString("Play", tableName: "Localization", comment: ""),
                color: Colors.text,
                iconName: "play.fill",
                textColor: Color("Background"),
                destination: AnyView(BoardView(player1: PlayerVM(player: HumanPlayer(withName: "Lou", andId: .player1)!), player2: PlayerVM(player: RandomPlayer(withName: "LouBis", andId: .player2)!)).navigationBarBackButtonHidden(true))
            ).padding()
            .navigationTitle(NSLocalizedString("New Game", tableName: "Localization", comment: ""))
            .navigationBarItems(
                leading:
                    Button(NSLocalizedString("Close", tableName: "Localization", comment: "")) {
                        dismiss()
                    }
            )
        }
    }
}

struct StartGamePopUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartGamePopUpView()
    }
}
