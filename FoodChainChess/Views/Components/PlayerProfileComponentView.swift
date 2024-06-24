//
//  PlayerProfileView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI

struct PlayerProfileComponentView: View {
    var playerUsername: String
    
    @ObservedObject var playerManager = PlayerManager.shared
    
    var body: some View {
        VStack {
            PlayerFaceView(
                imageSource: playerManager.getAvatarImage(for: playerUsername),
                circleWidth: 80,
                circleHeight: 80)
            Text(playerUsername)
        }
    }
}

struct PlayerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProfileComponentView(playerUsername: "LouSusQui")
    }
}
