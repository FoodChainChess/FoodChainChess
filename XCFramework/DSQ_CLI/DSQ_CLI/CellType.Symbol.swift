import Foundation
import DouShouQiModel

extension CellType {
    public var symbol: String {
        switch self{
        case .jungle:
            return "🌿"
        case .den:
            return "🪹"
        case .trap:
            return "🪤"
        case .water:
            return "💧"
        default:
            return "  "
        }
    }
}

