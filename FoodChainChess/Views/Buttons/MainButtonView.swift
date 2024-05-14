//
//  MainButtonView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct MainButtonView: View {
    var buttonText : String
    var color: Color
    var iconName: String?
    var textColor: Color = Color("Text")
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Text(buttonText)
                
                if let iconName = iconName {
                    Image(systemName: iconName)
                }
            }.frame(maxWidth: .infinity, alignment: .center)

        }
        .foregroundColor(textColor)
        .fontWeight(.semibold)
        .buttonStyle(.borderedProminent)
        .tint(color)
    }
}

struct MainButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MainButtonView(buttonText: "High Scores 🏆", color: Color("Primary"), textColor: Color("Text"))
            .font(.title)
            .padding(30)
    }
}
