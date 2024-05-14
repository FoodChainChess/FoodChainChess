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
    
    var body: some View {
        VStack {
            
            // Game Mode
            HStack {
                Text("Game Mode: \(selectedGameMode)")
                    .padding()
                 
                 Picker("Game Mode",
                        selection: $selectedGameMode) {
                     
                     Text("Player vs Player")
                         .tag("pvp")
                     
                     Text("Player vs Computer")
                         .tag("pve")
                     
                     Text("Multi-Device")
                         .tag("multi")
                 }
            }
           
           
           Button("Back") {
               isShowing = false
           }
           .padding()
       }
       .background(Color("Backrgound"))
       .cornerRadius(10)
       .padding()
    }
}

struct StartGamePopUpView_Previews: PreviewProvider {
    
    @State static var isShowing = true

    static var previews: some View {
        StartGamePopUpView(isShowing: $isShowing)
    }
}
