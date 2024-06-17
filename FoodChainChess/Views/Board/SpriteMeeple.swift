import Foundation
import SpriteKit
import DouShouQiModel

class SpriteMeeple: SKNode {
    static let offset = CGPoint(x: -300, y: -400)
    static let direction = CGVector(dx: 100, dy: 100)
    
    static var maxZPosition: CGFloat = 0
    
    /// Permet a gameVM de savoir quelle est la meeple en cours d'éxécution
    var isCurrentMeeple: Bool = false
    
    let imageNode: SKSpriteNode
    let ellipseNode: SKShapeNode
    var possibleMoves: [Move] = []
    
    var gameScene: GameScene {
        return (self.scene as? GameScene)!
    }
    
    var fromMovePosition: [Int] = []
    
    // Contient la position actuelle de la cellule dans le board
    var cellPosition: CGPoint {
        didSet {
            self.position.x = SpriteMeeple.offset.x + SpriteMeeple.direction.dx * cellPosition.x
            self.position.y = SpriteMeeple.offset.y + SpriteMeeple.direction.dy * cellPosition.y
        }
    }
    
    // Le owner de la piece actuelle
    var owner: Owner {
        didSet {
            print("Owner set to: \(owner)")
        }
    }
    
    // La piece actuelle
    var currentPiece: Piece? {
        didSet {
            // calculer les moves possibles lors du changement de la piece en cours
            if let currentPiece = self.currentPiece {
                possibleMoves = self.gameScene.gameVM.game.rules.getMoves(in: self.gameScene.gameVM.game.board, of: currentPiece.owner, fromRow: Int(self.cellPosition.y), andColumn: Int(self.cellPosition.x))
            }
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
        return self.gameScene.gameVM.currentPlayerVM.player.id == self.owner
    }
    
    /// Méthode déclenchée au début du mouvement de la pièce
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isOwnerCurrentPlayer() else {
            return
        }
        
        self.isCurrentMeeple = true
        
        if let touch = touches.first {
            let position = touch.location(in: self.gameScene)
            
            // position de la piece a partir de la zone touché
            let currentPiecePosition = nearestCellPosition(to: position)
            
            self.fromMovePosition = [Int(currentPiecePosition.y), Int(currentPiecePosition.x)]
            
            // definir la piece en cours
            self.currentPiece = self.gameScene.gameVM.game.board.grid[fromMovePosition[0]][fromMovePosition[1]].piece
            
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
        
        // Mettre a jour la position de la pièce en fonction du touch
        self.position = touches.first?.location(in: parent!) ?? CGPoint(x: 0, y: 0)
    }
    
    /// Méthode déclenchée à la fin du mouvement de la pièce
    /// - Parameters:
    ///   - touches: <#touches description#>
    ///   - event: <#event description#>
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isOwnerCurrentPlayer() else {
            // TODO: gestion d'erreur (throws ou retour de valeur d'erreur)
            return
        }
        // mettre cellule en cours au premier plan
        SpriteMeeple.maxZPosition += 1
        self.zPosition = SpriteMeeple.maxZPosition
        
        // recuperer la position du touch actuel
        let touchLocation = touches.first?.location(in: gameScene) ?? CGPoint.zero
        
        // mettre a jour la position de la cellule
        let nearestPosition = nearestCellPosition(to: touchLocation)
        self.cellPosition = nearestPosition
        
        // Si move fait parti des moves possibles
        let move = Move(of: self.gameScene.gameVM.currentPlayerVM.player.id, fromRow: self.fromMovePosition[0], andFromColumn: self.fromMovePosition[1], toRow: Int(self.cellPosition.y), andToColumn: Int(self.cellPosition.x))
        
            
            // Ajouter le move a currentPlayerVM
            self.gameScene.gameVM.currentPlayerVM.currentMove = move
            
            Task {
                //try! await (self.gameScene.gameVM.game.players[owner] as! HumanPlayer).chooseMove(move)
                try! await (self.gameScene.gameVM.currentPlayerVM.player as! HumanPlayer).chooseMove(move)
            }
        
        // check si le move est valide
        
        // appliquer le move si valide
        // afficher erreur si move pas valide
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
        let cellWidth = gameScene.imageBoard.size.width / CGFloat(self.gameScene.gameVM.game.board.nbColumns)
        let cellHeight = gameScene.imageBoard.size.height / CGFloat(self.gameScene.gameVM.game.board.nbRows)
        
        let col = Int((position.x + gameScene.imageBoard.size.width / 2) / cellWidth)
        let row = Int((position.y + gameScene.imageBoard.size.height / 2) / cellHeight)
        
        if let piece = self.gameScene.gameVM.game.board.grid[row][col].piece {
            let possibleMoves = self.gameScene.gameVM.game.rules.getMoves(in: self.gameScene.gameVM.game.board, of: piece.owner, fromRow: row, andColumn: col)
            gameScene.highlightMoves(possibleMoves)
        }
    }
    
    /// Remet la piece a la position initiale d'un move
    func resetPiecePosition() {
        self.position.x = SpriteMeeple.offset.x + SpriteMeeple.direction.dx * CGFloat(self.fromMovePosition[1])
        self.position.y = SpriteMeeple.offset.y + SpriteMeeple.direction.dy * CGFloat(self.fromMovePosition[0])
        
        self.isCurrentMeeple = false
    }
}

