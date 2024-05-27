import Foundation
import DouShouQiModel

extension Owner {
    public var symbol: String {
        switch self {
        case .player1:
            return "🟡"
        case .player2:
            return "🔴"
        default:
            return "  "
        }
    }
}
