//
//  ModeSwitchView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI

struct ModeSwitchView: View {
    
    @State private var darkMode = false

    var body: some View {
        VStack{
            Toggle(isOn: $darkMode) {
                Text("Dark Mode")
            }
            .padding(.horizontal, 60) // Padding Horizontal entre le texte et le switch button
        }
    }
}

struct ModeSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSwitchView()
    }
}
