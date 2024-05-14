//
//  StartGamePopUpView.swift
//  FoodChainChess
//
//  Created by étudiant on 14/05/2024.
//

import SwiftUI

struct StartGamePopUpView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
           Text("Pop-up!")
               .padding()
           
           Button("Close") {
               isShowing = false
           }
           .padding()
       }
       .background(Color("Backrgound"))
       .cornerRadius(10)
       .padding()
    }
}

struct StartGamePopUpView_Previews: PreviewProvider {
    
    @State static var isShowing = true

    static var previews: some View {
        StartGamePopUpView(isShowing: $isShowing)
    }
}
