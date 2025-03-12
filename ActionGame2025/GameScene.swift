import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var sprite : SKSpriteNode!
    var opponentSprite: SKSpriteNode!
    
    let spriteCategory1 : UInt32 = 0b1
    let spriteCategory2 : UInt32 = 0b10


    override func didMove(to view: SKView) {
            // Enable physics contact delegate
            self.physicsWorld.contactDelegate = self

            // Add Player Sprite
            sprite = SKSpriteNode(imageNamed: "PlayerSprite")
            sprite.position = CGPoint(x: size.width / 2, y: size.height / 2)
            sprite.size = CGSize(width: 300, height: 300)
            addChild(sprite)

            // Add Physics Body to Player
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
            sprite.physicsBody?.categoryBitMask = spriteCategory1
            sprite.physicsBody?.contactTestBitMask = spriteCategory2
            sprite.physicsBody?.collisionBitMask = spriteCategory2
            sprite.physicsBody?.affectedByGravity = false  // Prevent falling
            sprite.physicsBody?.isDynamic = true           // Allows movement

            // Add Opponent Sprite
            opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
            opponentSprite.position = CGPoint(x: size.width / 2, y: size.height)
            opponentSprite.size = CGSize(width: 150, height: 150)
            addChild(opponentSprite)

            // Add Physics Body to Opponent
            opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
            opponentSprite.physicsBody?.categoryBitMask = spriteCategory2
            opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
            opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
            opponentSprite.physicsBody?.affectedByGravity = false
            opponentSprite.physicsBody?.isDynamic = true  // Allows movement

            // Define Movement Actions
            let downMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: 0), duration: 1)
            let upMovement = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height), duration: 1)
            let movement = SKAction.sequence([downMovement, upMovement])

            // Run Movement Loop
            opponentSprite.run(SKAction.repeatForever(movement))
        }
    
    // Collision Detection
        func didBegin(_ contact: SKPhysicsContact) {
            print("Hit!")  // Prints when PlayerSprite collides with OpponentSprite
        }


    func touchDown(atPoint pos : CGPoint) {}

    func touchMoved(toPoint pos : CGPoint) {}

    func touchUp(atPoint pos : CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {}
}

