//
//  CircularButtonView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct IconButtonView: View {
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: iconName)
        }
        .buttonStyle(IconButtonStyle())
    }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonView(iconName: "gearshape.fill", action: {
            // Debug
            print("Just debug")
        })
    }
}
