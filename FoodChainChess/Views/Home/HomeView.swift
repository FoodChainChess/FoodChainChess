//
//  HomeView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingPopUp2 = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    IconButtonView(
                        iconName: "gearshape.fill",
                        size: .small,
                        destination: AnyView(ParametersView())
                    ).padding()
                    Spacer()
                    
                    Text("Home", tableName: "Localization")
                        .TextStyle(TitleTextStyle())
                        .padding(.top, 40)
                    
                    Spacer()
                    IconButtonView(
                        iconName: "person.badge.plus.fill",
                        size: .small,
                        destination: AnyView(CreatePlayerView())
                    ).padding()
                }
                Spacer()
                
                VStack(spacing: 35) {
                    MainButtonView(
                        buttonText: "Play",
                        color: Colors.primary,
                        iconName: "play.fill",
                        textColor: Color("Background"),
                        destination: AnyView(StartGamePopUpView().navigationBarBackButtonHidden(true)))
                    
                    MainButtonView(
                        buttonText: "High Scores",
                        color: Colors.primary,
                        iconName: "trophy.fill",
                        destination: AnyView(ScoreboardView()))
                    
                    MainButtonView(
                        buttonText:"Saved Games",
                        color: Colors.primary,
                        iconName: "folder.fill",
                        destination: AnyView(GamesView()))
                    
                    MainButtonView(
                        buttonText: "Keep Playing",
                        color: Colors.primary,
                        iconName: "arrow.right.circle",
                        destination: AnyView(RegisteredGamesView()))
                    
                }
                .padding(70)
                .font(.title2)
                
                
                Spacer()
            }.sheet(isPresented: $isShowingPopUp2) {
                EndGamePopUpView(
                    isShowing: $isShowingPopUp2,
                    playerOneScore: 10,
                    playerTwoScore: 2,
                    playerUsername1: "Nicolas",
                    playerUsername2: "Lou",
                    winReason: "Den reached.")
            }.background(Colors.background)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
