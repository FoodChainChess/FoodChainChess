import Foundation
import SpriteKit
import DouShouQiModel

class SpriteMeeple: SKNode {
    static let offset = CGPoint(x: -300, y: -400)
    static let direction = CGVector(dx: 100, dy: 100)

    static var maxZPosition: CGFloat = 0

    let imageNode: SKSpriteNode
    let ellipseNode: SKShapeNode
    
    var gameScene: GameScene? {
        return self.scene as? GameScene
    }

    var cellPosition: CGPoint {
        didSet {
            self.position.x = SpriteMeeple.offset.x + SpriteMeeple.direction.dx * cellPosition.x
            self.position.y = SpriteMeeple.offset.y + SpriteMeeple.direction.dy * cellPosition.y
        }
    }
    
    var owner: Owner {
        didSet {
            print("Owner set to: \(owner)")
        }
    }
    
    init(imageNamed imageName: String, size: CGSize, backgroundColor: UIColor, owner: Owner) {
        imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.size = CGSize(width: size.width, height: size.height)
        ellipseNode = SKShapeNode(ellipseOf: CGSize(width: size.width, height: size.height))
        ellipseNode.fillColor = backgroundColor

        self.cellPosition = CGPoint(x: 0, y: 0)
        self.owner = owner
        
        super.init()
        self.addChild(ellipseNode)
        self.addChild(imageNode)
    }

    required init?(coder aDecoder: NSCoder) {
        imageNode = SKSpriteNode(imageNamed: "defaultAvatarPicture")
        ellipseNode = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100))

        self.cellPosition = CGPoint(x: 0, y: 0)
        self.owner = .player1

        super.init(coder: aDecoder)
    }
    
    /// Permet de rendre les interactions de l'utilisateur possibles
    override var isUserInteractionEnabled: Bool {
        set {}
        get { true }
    }
    
    /// Permet de savoir si le possesseur de la pièce est le joueur actuel
    /// - Returns: True s'il s'agit du joueur actuel, False sinon
    private func isOwnerCurrentPlayer() -> Bool {
        guard let gameScene = self.gameScene else {
            return false
        }
        return gameScene.currentPlayer == self.owner
    }
    
    /// Méthode déclenchée au début du mouvement de la pièce
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isOwnerCurrentPlayer() else {
            return
        }
        
        if let touch = touches.first {
            let position = touch.location(in: self.gameScene!)
            highlightNodes(from: position)
        }
    }
    
    /// Méthode déclenchée durant le mouvement de la pièce
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isOwnerCurrentPlayer() else {
            return
        }
        
        self.position = touches.first?.location(in: parent!) ?? CGPoint(x: 0, y: 0)
    }
    
    /// Méthode déclenchée à la fin du mouvement de la pièce
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isOwnerCurrentPlayer() else {
            return
        }
        
        guard let parent = parent as? GameScene else { return }

        let touchLocation = touches.first?.location(in: parent) ?? CGPoint.zero
        let nearestPosition = nearestCellPosition(to: touchLocation)

        SpriteMeeple.maxZPosition += 1
        self.zPosition = SpriteMeeple.maxZPosition

        self.cellPosition = nearestPosition
        
        // Mise à jour du modèle de jeu après le déplacement
        if let piece = parent.game.board.grid[Int(self.cellPosition.y)][Int(self.cellPosition.x)].piece {
            let possibleMoves = parent.game.rules.getMoves(in: parent.game.board, of: piece.owner, fromRow: Int(self.cellPosition.y), andColumn: Int(self.cellPosition.x))
            if let move = possibleMoves.first(where: { $0.rowDestination == Int(self.cellPosition.y) && $0.columnDestination == Int(self.cellPosition.x) }) {
                parent.applyMove(move)
            }
        }
    }

    
    /// Permet d'avoir la case la plus proche depuis la position fournie
    /// - Parameter point: Position actuelle de la pièce
    /// - Returns: Position de la case la plus proche
    private func nearestCellPosition(to point: CGPoint) -> CGPoint {
        let x = round((point.x - SpriteMeeple.offset.x) / SpriteMeeple.direction.dx)
        let y = round((point.y - SpriteMeeple.offset.y) / SpriteMeeple.direction.dy)
        return CGPoint(x: x, y: y)
    }
    
    /// Permet d'afficher les cases de destination possibles lors de la sélection d'une pièce
    /// - Parameter position: Position initiale de la pièce
    func highlightNodes(from position: CGPoint) {
        guard let gameScene = self.gameScene else { return }

        let cellWidth = gameScene.imageBoard.size.width / CGFloat(gameScene.game.board.nbColumns)
        let cellHeight = gameScene.imageBoard.size.height / CGFloat(gameScene.game.board.nbRows)

        let col = Int((position.x + gameScene.imageBoard.size.width / 2) / cellWidth)
        let row = Int((position.y + gameScene.imageBoard.size.height / 2) / cellHeight)

        if let piece = gameScene.game.board.grid[row][col].piece {
            let possibleMoves = gameScene.game.rules.getMoves(in: gameScene.game.board, of: piece.owner, fromRow: row, andColumn: col)
            gameScene.highlightMoves(possibleMoves)
        }
    }
}
