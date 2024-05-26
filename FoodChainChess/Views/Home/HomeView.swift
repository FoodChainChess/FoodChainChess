//
//  HomeView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingPopUp = false
    @State private var isShowingPopUp2 = false
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    IconButtonView(
                        iconName: "gearshape.fill",
                        size: .small,
                        destination: AnyView(ParametersView().navigationBarBackButtonHidden(true))
                    ).padding()
                    Spacer()
                    
                    Text("Home")
                        .TextStyle(TitleTextStyle())
                        .padding(.top, 40)
                    
                    Spacer()
                    IconButtonView(
                        iconName: "person.badge.plus.fill",
                        size: .small,
                        destination: AnyView(CreatePlayerView().navigationBarBackButtonHidden(true))
                    ).padding()
                }
                Spacer()
                
                VStack(spacing: 24) {
                    MainButtonView(
                        buttonText: "Play",
                        color: Colors.text,
                        iconName: "play.fill",
                        textColor: Color("Background"),
                        action: { isShowingPopUp.toggle() })
                    
                    MainButtonView(
                        buttonText: "High Scores 🏆",
                        color: Color("Primary"),
                        destination: AnyView(ScoreboardView().navigationBarBackButtonHidden(true)))
                    
                    MainButtonView(
                        buttonText: "Saved Games 💾",
                        color: Color("Accent"),
                        destination: AnyView(GamesView().navigationBarBackButtonHidden(true)))
                    
//                    MainButtonView(
//                        buttonText: "Keep Playing",
//                        color: Color("Secondary"),
//                        iconName: "arrow.right.circle",
//                        action: {isShowingAlert = true })
//                    .alert(isPresented: $isShowingAlert) {
//                        Alert(
//                            title: Text("Save the game before quitting ?"),
//                            message: Text("If you don't save the game, it will be lost."),
//                            
//                            primaryButton: .default(
//                                Text("Yes")
//                            ),
//                            
//                            secondaryButton: .destructive(
//                                Text("No")
//                            )
//                        )
//                    }
                    
                    MainButtonView(
                        buttonText: "Keep Playing",
                        color: Color("Secondary"),
                        iconName: "arrow.right.circle",
                        destination: AnyView(RegisteredGamesView().navigationBarBackButtonHidden(true)))

                }
                .font(.title2)
                .padding(80)
                
                Spacer()
            }.sheet(isPresented: $isShowingPopUp) {
                StartGamePopUpView(isShowing: $isShowingPopUp)
            }.sheet(isPresented: $isShowingPopUp2) {
                EndGamePopUpView(
                    isShowing: $isShowingPopUp2,
                    playerOneScore: 10,
                    playerTwoScore: 2,
                    playerUsername1: "Nicolas",
                    playerUsername2: "Lou",
                    winReason: "Den reached.")
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
