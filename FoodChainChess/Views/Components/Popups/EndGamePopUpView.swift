//
//  EndGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI

// ! Attention !
// Cette vue n'a pas été utilisé dans la version finale de notre application.

struct EndGamePopUpView: View {
    // { TODO: use player object as parameter }
    var playerOneScore: Int
    var playerTwoScore: Int
    
    var playerUsername1: String
    var playerUsername2: String
    
    var winReason: String
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
//                HStack {
//                    Button(NSLocalizedString("Close", tableName: "Localization", comment: "")) {
//                    }
//                    .padding(20)
//                    
//                    Spacer()
//                }
//                
//                Spacer()
                
                Text("Game Ended", tableName: "Localization")
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
                
                Text(winReason)
                    .padding(.bottom, 25)

                
                // Buttons
                HStack {
                    MainButtonView(
                        buttonText: "\(NSLocalizedString("Home", tableName: "Localization", comment: "")) 🏠",
                        color: Color("Primary"),
                        destination: AnyView(HomeView().navigationBarBackButtonHidden(true)))
                    
                    MainButtonView(
                        buttonText: "\(NSLocalizedString("Rematch", tableName: "Localization", comment: "")) 🔄",
                        color: Color("Accent"),
                        destination: AnyView(StartGamePopUpView().navigationBarBackButtonHidden(true)))
                }
                .padding(30)

                
                Spacer()
                Spacer()
            }
        }
        
    }
}

struct EndGamePopUpView_Previews: PreviewProvider {
    static var previews: some View {
        EndGamePopUpView(
            playerOneScore: 13,
            playerTwoScore: 0,
            playerUsername1: "NicolasTop1",
            playerUsername2: "LouSusQi",
            winReason: "Den reached."
        )
    }
}
