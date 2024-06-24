//
//  StartGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI
import DouShouQiModel

struct StartGamePopUpView: View {
    @State private var selectedGameMode: String = "pvp"
    @State private var selectedGameRules: String = "cr"
    @State private var selectedPlayer1: String = "Player 1"
    @State private var selectedPlayer2: String = "Player 2"
    @State private var isNavigationActive = false
    
    @EnvironmentObject var gameManager: GameSceneManager

    var playerManager = PlayerManager.shared
    
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
                    .onChange(of: selectedGameMode) { newValue in
                        if newValue == "pve" {
                            selectedPlayer2 = "Bot"
                        } else {
                            selectedPlayer2 = "Player 2"
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                // Rules selection
                Section(header: Text("Select Game Rules")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)) {
                    Picker(NSLocalizedString("Game Rules", tableName: "Localization", comment: ""),
                           selection: $selectedGameRules) {
                        
                        Text("Classic Rules", tableName: "Localization")
                            .tag("cr")
                        
                        Text("Simple Rules", tableName: "Localization")
                            .tag("sr")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: selectedGameRules) { newValue in
                        if newValue == "cr" {
                            print("Classic Rules")
                            playerManager.rules = ClassicRules()
                            gameManager.gameScene.gameVM.initGame()
                        } else {
                            print("Very Simple Rules")
                            playerManager.rules = VerySimpleRules()
                            gameManager.gameScene.gameVM.initGame()
                        }
                    }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                // Player Selection
                Section(header: Text(NSLocalizedString("Select Players", tableName: "Localization", comment: ""))
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.top)) {
                    
                    // Player 1 Picker
                    Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 1",
                           selection: $selectedPlayer1) {
                        
                        ForEach(playerManager.createdPlayers.filter { $0.name != "Bot" }, id: \.name) { player in
                            Text(player.name).tag(player.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    
                    // Player 2 Picker
                    if selectedGameMode == "pve" {
                        Text("Bot")
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    } else {
                        Picker("\(NSLocalizedString("Player", tableName: "Localization", comment: "")) 2",
                               selection: $selectedPlayer2) {
                            
                            ForEach(playerManager.createdPlayers.filter { $0.name != selectedPlayer1 && $0.name != "Bot" }, id: \.name) { player in
                                Text(player.name).tag(player.name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Game Settings", displayMode: .inline)
            .padding()
            
            // MainButtonView with action and navigation
            MainButtonView(
                buttonText: NSLocalizedString("Play", tableName: "Localization", comment: ""),
                color: Colors.text,
                iconName: "play.fill",
                textColor: Color("Background"),
                action: {
                    if let newPlayer1 = playerManager.getPlayerByUsername(self.selectedPlayer1) {
                        playerManager.selectedPlayer1 = PlayerVM(player: newPlayer1)
                    }
                    if let newPlayer2 = playerManager.getPlayerByUsername(self.selectedPlayer2) {
                        playerManager.selectedPlayer2 = PlayerVM(player: newPlayer2)
                    }
                    
                    // make sure ids are different
                    playerManager.adjustSelectedPlayersId()
                    
                    print("Selected player 1 \(playerManager.selectedPlayer1.player.name)")
                    
                    // Set navigation active after action
                    self.isNavigationActive = true
                }
            )
            .padding()
            .navigationTitle(NSLocalizedString("New Game", tableName: "Localization", comment: ""))
            
            // Navigation to BoardView
            NavigationLink(
                destination: BoardView().navigationBarBackButtonHidden(true),
                isActive: $isNavigationActive,
                label: { EmptyView() }
            )
        }
    }
}

//struct StartGamePopUpView_Previews: PreviewProvider {
//    @State static var isShowing = true
//    
//    static var previews: some View {
//        
//        return StartGamePopUpView()
//    }
//}

