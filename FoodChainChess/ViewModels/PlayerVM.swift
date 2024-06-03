import Foundation
import DouShouQiModel

class PlayerVM: ObservableObject {

    @Published var player: Player
    
    public init(player: Player){
        self.player = player
    }
}
