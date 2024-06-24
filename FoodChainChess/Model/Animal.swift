import Foundation
import DouShouQiModel

extension Animal {
    var soundFileName: String {
        switch self {
        case .rat:
            return "rat_sound"
        case .cat:
            return "cat_sound"
        case .dog:
            return "dog_sound"
        case .wolf:
            return "wolf_sound"
        case .leopard:
            return "leopard_sound"
        case .tiger:
            return "tiger_sound"
        case .lion:
            return "lion_sound"
        case .elephant:
            return "elephant_sound"
        @unknown default:
            return ""
        }
    }
}
