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
                    size: .small
                )
                Spacer()
                
                Text("Home")
                    .TextStyle(TitleTextStyle())
                    .padding(.top, 40)
                
                Spacer()
                IconButtonView(
                    iconName: "person.badge.plus.fill",
                    size: .small
                )
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
                    color: Color("Primary"))
                
                MainButtonView(
                    buttonText: "Saved Games 💾",
                    color: Color("Accent"))
                
                MainButtonView(
                    buttonText: "Keep Playing",
                    color: Color("Secondary"),
                    iconName: "arrow.right.circle")

            }
            .font(.title2)
            .padding(80)
            
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
