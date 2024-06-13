import Foundation
import DouShouQiModel

class PlayerVM: ObservableObject {

    @Published var player: Player
    
    @Published var currentMove: Move? {
        didSet {
            if let currentMove = self.currentMove {
                print("current move changed: \(currentMove)")
            }
        }
    }
    
    public init(player: Player){
        self.player = player
    }
}
