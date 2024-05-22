import Foundation
import SpriteKit

class SpriteMeeple : SKNode {
    static let offset = CGPoint(x: -400, y: -300)
    static let direction = CGVector(dx: 100, dy: 100)
    
    let imageNode: SKSpriteNode
    let ellipseNode: SKShapeNode
    
    
    var cellPosition : CGPoint {
        didSet(value) { // il y a un truc à changer ici, j'ai pas reussi à copier
            self.position.x = SpriteMeeple.offset.x + SpriteMeeple.direction.dx * cellPosition.x
            self.position.y = SpriteMeeple.offset.y + SpriteMeeple.direction.dy * cellPosition.y

        }
    }
    
    
    init(imageNamed imageName : String, size : CGSize, backgroundColor : UIColor) {
        imageNode = SKSpriteNode(imageNamed: imageName)
        imageNode.size = CGSize(width: size.width, height: size.height)
        ellipseNode = SKShapeNode(ellipseOf: CGSize(width: size.width, height: size.height))
        ellipseNode.fillColor = backgroundColor
        
        self.cellPosition = CGPoint(x: 0, y: 0)
        
        super.init()
        self.addChild(ellipseNode)
        self.addChild(imageNode)
    }
    
    override required init?(coder aDecoder: NSCoder) {
        imageNode = SKSpriteNode(imageNamed: "defaultAvatarPicture")
        ellipseNode = SKShapeNode(ellipseOf: CGSize(width: 100, height: 100))
        
        self.cellPosition = CGPoint(x: 0, y: 0)

        super.init(coder: aDecoder)
    }
    
    override var isUserInteractionEnabled: Bool {
        set {}
        get{true}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.position =
            touches.first?.location(in: parent!) ?? CGPoint(x: 0, y: 0)
    }
}
