//
//  HomeView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct HomeView: View {    
    var body: some View {
        NavigationStack {
            Image("HomeBackground")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .overlay(
            VStack {
                HStack {
                    IconButtonView(
                        iconName: "gearshape.fill",
                        size: .small,
                        destination: AnyView(ParametersView())
                    ).padding()
                    Spacer()
                    
                    Text("Home", tableName: "Localization")
                        .TextStyle(TitleHomeTextStyle())
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
                        buttonText: NSLocalizedString("Play", tableName: "Localization", comment: ""),
                        color: Colors.primary,
                        iconName: "play.fill",
                        destination: AnyView(StartGamePopUpView()))
                    
                    MainButtonView(
                        buttonText: (NSLocalizedString("High Scores", tableName: "Localization", comment: "")),
                        color: Colors.primary,
                        iconName: "trophy.fill",
                        destination: AnyView(ScoreboardView()))
                    
                    MainButtonView(
                        buttonText:(NSLocalizedString("Saved Games", tableName: "Localization", comment: "")),
                        color: Colors.primary,
                        iconName: "folder.fill",
                        destination: AnyView(GamesView()))
                    
                    MainButtonView(
                        buttonText: NSLocalizedString("Keep Playing", tableName: "Localization", comment: ""),
                        color: Colors.primary,
                        iconName: "arrow.right.circle",
                        destination: AnyView(RegisteredGamesView()))
                    
                }
                .padding(70)
                .font(.title2)
                
                Spacer()
            }
        )}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
