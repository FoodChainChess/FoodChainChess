//
//  StartGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct StartGamePopUpView: View {
    @Binding var isShowing: Bool
    
    @State private var selectedGameMode: String = "PvP"
    @State private var selectedPlayer1: String = "none"
    @State private var selectedPlayer2: String = "none"
    
    var body: some View {
        NavigationStack {
            Form {
                // Game mode selection
                Picker("Game Mode",
                       selection: $selectedGameMode) {
                    
                    Text("Player vs Player")
                        .tag("pvp")
                    
                    Text("Player vs Computer")
                        .tag("pve")
                    
                    Text("Multi-Device")
                        .tag("multi")
                }
               .pickerStyle(.navigationLink)
                
                // Player Selection
                Picker("Player 1",
                       selection: $selectedPlayer1) {
                    
                    Text("Ronaldo")
                        .tag("Roanldo")
                    
                    Text("Messi")
                        .tag("Messi")
                }
                
                Picker("Player 2",
                       selection: $selectedPlayer2) {
                    
                    Text("Neymar")
                        .tag("Neymar")
                    
                    Text("Haaland")
                        .tag("Haaland")
                }
            }
            .navigationTitle("New Game")
            .navigationBarItems(
                leading:
                    Button("Close") {
                        isShowing = false
                    }
            )
        }
    }
}

struct StartGamePopUpView_Previews: PreviewProvider {
    
    @State static var isShowing = true

    static var previews: some View {
        StartGamePopUpView(isShowing: $isShowing)
    }
}
