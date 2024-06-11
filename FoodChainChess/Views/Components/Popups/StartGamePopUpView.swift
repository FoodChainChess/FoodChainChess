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
            VStack(alignment: .leading, spacing: 20) {
                // Game mode selection
                Section(header: Text(NSLocalizedString("Select Game Mode", tableName: "Localization", comment: ""))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)) {
                    Picker(NSLocalizedString("Game Mode", tableName: "Localization", comment: ""),
                           selection: $selectedGameMode) {
                        
                        Text("PvP", tableName: "Localization")
                            .tag("pvp")
                        
                        Text("Player vs Computer", tableName: "Localization")
                            .tag("pve")
                        
                        Text("Multi-Device", tableName: "Localization")
                            .tag("multi")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                // Player Selection
                Section(header: Text(NSLocalizedString("Select Players", tableName: "Localization", comment: ""))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)) {
                    Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 1",
                           selection: $selectedPlayer1) {
                        
                        ForEach(0..<playerManager.createdPlayers.count, id: \.self) { index in
                            Text(playerManager.createdPlayers[index].name)
                                .tag(playerManager.createdPlayers[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    
                    Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 2",
                           selection: $selectedPlayer2) {
                        
                        ForEach(0..<playerManager.createdPlayers.count, id: \.self) { index in
                            Text(playerManager.createdPlayers[index].name)
                                .tag(playerManager.createdPlayers[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Game Settings", displayMode: .inline)
            .padding()
        }
            MainButtonView(
                buttonText: NSLocalizedString("Play", tableName: "Localization", comment: ""),
                color: Colors.text,
                iconName: "play.fill",
                textColor: Color("Background"),
                destination: AnyView(BoardView(player1: HumanPlayer(withName: "Lou", andId: .player1)!, player2: HumanPlayer(withName: "LouBis", andId: .player2)!).navigationBarBackButtonHidden(true))
            ).padding()
            .navigationTitle(NSLocalizedString("New Game", tableName: "Localization", comment: ""))
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

