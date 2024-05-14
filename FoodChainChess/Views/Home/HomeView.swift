//
//  HomeView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingPopUp = false
    
    var body: some View {
        VStack {
            HStack {
                IconButtonView(
                    iconName: "gearshape.fill",
                    action: {},
                    size: ButtonSize.small.rawValue
                )
                Spacer()
                
                Text("Home")
                    .TextStyle(TitleTextStyle())
                    .padding(.top, 40)
                
                Spacer()
                IconButtonView(
                    iconName: "person.badge.plus.fill",
                    action: {},
                    size: ButtonSize.small.rawValue
                )
            }
            Spacer()
            
            VStack(spacing: 24) {
                MainButtonView(
                    buttonText: "Play",
                    color: Color("Text"),
                    iconName: "play.fill",
                    textColor: Color("Background"),
                    action: { isShowingPopUp.toggle() })
                .font(.title2)
                
                MainButtonView(
                    buttonText: "High Scores 🏆",
                    color: Color("Primary"))
                .font(.title2)
                
                MainButtonView(
                    buttonText: "Saved Games 💾",
                    color: Color("Accent"))
                .font(.title2)
                
                MainButtonView(
                    buttonText: "Keep Playing",
                    color: Color("Secondary"),
                    iconName: "arrow.right.circle")
                .font(.title2)

            }.padding(80)
            
            Spacer()
        }.sheet(isPresented: $isShowingPopUp) {
            StartGamePopUpView(isShowing: $isShowingPopUp)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
