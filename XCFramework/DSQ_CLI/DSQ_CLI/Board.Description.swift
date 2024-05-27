import Foundation
import DouShouQiModel

extension Board : CustomStringConvertible {
    public var description: String {
        var string = String()
        for r in 0..<nbRows {
            for c in 0..<nbColumns {
                let cellString = grid[r][c].cellType.symbol
                let animalString = grid[r][c].piece?.animal.symbol ?? "  "
                let ownerString = grid[r][c].piece?.owner.symbol ?? "  "
                string.append("\(cellString)\(animalString)\(ownerString)  ")
            }
            string.append("\n\n")
        }
        return string
    }
}

