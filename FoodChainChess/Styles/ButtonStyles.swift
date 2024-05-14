//
//  ButtonStyles.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import Foundation
import SwiftUI

struct IconButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label // ?? understand later
            .foregroundColor(Color("Text"))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
