//
//  EndGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI


struct EndGamePopUpView: View {
    @Binding var isShowing: Bool
    
    // { TODO: use player object as parameter }
    var playerOneScore: Int
    var playerTwoScore: Int
    
    var playerUsername1: String
    var playerUsername2: String
    
    var winReason: String
    
    var body: some View {
        VStack {
            
            HStack {
                Button("x") {
                    isShowing = false
                }
                .font(.title)
                .padding(20)
                
                Spacer()
            }
            
            Spacer()
            
            Text("Game Ended")
                .TextStyle(TitleTextStyle())
                .padding(.bottom, 0)
            
            // Scores
            HStack {
                
                // user profile 1
                PlayerProfileComponentView(
                    playerUsername: playerUsername1)

                // player score
                PlayerScoreComponentView(
                    playerOneScore: playerOneScore,
                    playerTwoScore: playerTwoScore)
                .padding(20)
                
                // user profile 2
                PlayerProfileComponentView(
                    playerUsername: playerUsername2)
            }
            .padding(.bottom, 25)
            
            Text("Den reached.")
                .padding(.bottom, 25)

            
            // Buttons
            HStack {
                MainButtonView(
                    buttonText: "Home 🏠",
                    color: Color("Primary"))
                
                MainButtonView(
                    buttonText: "Rematch 🔄",
                    color: Color("Accent"))
            }
            .padding(30)

            
            Spacer()
            Spacer()
        }
    }
}

struct EndGamePopUpView_Previews: PreviewProvider {
    @State static var isShowing = true

    static var previews: some View {
        EndGamePopUpView(
            isShowing: $isShowing,
            playerOneScore: 13,
            playerTwoScore: 0,
            playerUsername1: "NicolasTop1",
            playerUsername2: "LouSusQi",
            winReason: "Den reached."
        )
    }
}
