//
//  ParametersView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI

struct ParametersView: View {
    
    
    var body: some View {
        VStack {
            TopBarTitleBackArrowView(title: "Parameters")
            Spacer()
            ModeSwitchView()
            Spacer()
        }
    }
}

struct ParametersView_Previews: PreviewProvider {
    static var previews: some View {
        ParametersView()
    }
}
