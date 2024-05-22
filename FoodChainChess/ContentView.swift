//
//  ContentView.swift
//  FoodChainChess
//
//  Created by étudiant on 13/05/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var gameScene : GameScene = GameScene(size: CGSize(width: 940, height: 740))
    
    
    var body: some View {
        VStack {
            SpriteView(scene: gameScene)
        }
        .padding()
        
    }
        .task {
            try : await
            gameScene.game.start()
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
