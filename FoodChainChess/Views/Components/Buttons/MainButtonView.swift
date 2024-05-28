//
//  MainButtonView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct MainButtonView: View {
    var buttonText: String
    var color: Color
    var iconName: String?
    var textColor: Color = .white
    var action: (() -> Void)?
    var destination: AnyView?
    
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    buttonContent
                }
                .foregroundColor(textColor)
                .buttonStyle(.borderedProminent)
                .tint(color)
            } else {
                Button(action: {
                    action?()
                }) {
                    buttonContent
                }
                .foregroundColor(textColor)
                .buttonStyle(.borderedProminent)
                .tint(color)
            }
        }
    }
    
    private var buttonContent: some View {
        HStack {
            Text(buttonText)
            
            if let iconName = iconName {
                Image(systemName: iconName)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .fontWeight(.semibold)
    }
}

struct MainButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                MainButtonView(
                    buttonText: "High Scores 🏆",
                    color: Color("Primary"),
                    iconName: nil,
                    destination: AnyView(ScoreboardView())
                )
                .font(.title)
                .padding(30)
            }
        }
    }
}
