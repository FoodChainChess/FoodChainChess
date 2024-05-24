import Foundation
import DouShouQiModel

extension Animal {
    public var symbol: String {
        switch self{
        case .rat:
            return "🐭"
        case .cat:
            return "🐱"
        case .dog:
            return "🐶"
        case .wolf:
            return "🐺"
        case .leopard:
            return "🐆"
        case .tiger:
            return "🐯"
        case .lion:
            return "🦁"
        case .elephant:
            return "🐘"
        @unknown default:
            return "🐥"
        }
    }
}
