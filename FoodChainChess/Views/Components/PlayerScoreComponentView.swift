//
//  PlayerScoreComponentView.swift
//  FoodChainChess
//
//  Created by étudiant on 22/05/2024.
//

import SwiftUI

struct PlayerScoreComponentView: View {
    var playerOneScore: Int
    var playerTwoScore: Int
    
    var body: some View {
        HStack {
            Text(String(playerOneScore))
                .TextStyle(ScoreTextStyle(
                    isBold: playerOneScore > playerTwoScore ? true : false
             ))
            Text("-")
            
            Text(String(playerTwoScore))
                .TextStyle(ScoreTextStyle(
                    isBold: playerTwoScore > playerOneScore ? true : false
            ))
        }
        .padding(.bottom, 20)    }
}

struct PlayerScoreComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerScoreComponentView(playerOneScore: 1, playerTwoScore: 0)
    }
}
