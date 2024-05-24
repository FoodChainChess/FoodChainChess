//
//  CircularButtonView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct IconButtonView: View {
    var iconName: String
    var action: () -> Void = {}
    var size: ButtonSize
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: size.rawValue))
        }
        .buttonStyle(IconButtonStyle())
    }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonView(
            iconName: "gearshape.fill",
            action: {},
            size: .small)
    }
}
