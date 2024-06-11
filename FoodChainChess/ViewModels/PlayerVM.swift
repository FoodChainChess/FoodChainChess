import Foundation
import DouShouQiModel

class PlayerVM: ObservableObject {

    @Published var player: Player
    
    @Published var currentMove: Move?
    
    public init(player: Player){
        self.player = player
    }
}
