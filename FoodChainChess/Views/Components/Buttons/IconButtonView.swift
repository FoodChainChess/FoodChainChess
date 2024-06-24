//
//  CircularButtonView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct IconButtonView: View {
    var iconName: String
    var size: ButtonSize
    var action: (() -> Void)?
    var destination: AnyView?
    
    var body: some View {
            Group {
                if let destination = destination {
                    NavigationLink(destination: destination) {
                        Image(systemName: iconName)
                            .font(.system(size: size.rawValue))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Button(action: {
                        action?()
                    }) {
                        Image(systemName: iconName)
                            .font(.system(size: size.rawValue))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonView(
            iconName: "gearshape.fill",
            size: .small,
            action: {})
    }
}
