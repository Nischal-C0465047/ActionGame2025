import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sprite: SKSpriteNode!  // Player sprite
    var opponentSprite: SKSpriteNode!  // Opponent sprite

    let spriteCategory1: UInt32 = 0b1  // Player physics category
    let spriteCategory2: UInt32 = 0b10  // Opponent physics category

    override func didMove(to view: SKView) {
        // Enable physics contact delegate
        self.physicsWorld.contactDelegate = self

        // Add Player Sprite
        sprite = SKSpriteNode(imageNamed: "PlayerSprite")
        sprite.position = CGPoint(x: size.width / 2, y: size.height * 0.1) // Position near bottom
        sprite.size = CGSize(width: 150, height: 150)
        addChild(sprite)

        // Add physics to PlayerSprite
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        sprite.physicsBody?.categoryBitMask = spriteCategory1
        sprite.physicsBody?.contactTestBitMask = spriteCategory2
        sprite.physicsBody?.collisionBitMask = spriteCategory2
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = true

        // Add Opponent Sprite
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")
        resetOpponentPosition() // Randomize starting position
        opponentSprite.size = CGSize(width: 100, height: 100)
        addChild(opponentSprite)

        // Add physics to OpponentSprite
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory2
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        opponentSprite.physicsBody?.affectedByGravity = false
        opponentSprite.physicsBody?.isDynamic = true

        // Start Opponent Movement
        moveOpponent()
    }

    // Function to set opponent's position at a random X value at the top
    func resetOpponentPosition() {
        let randomX = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(size.width)))
        opponentSprite.position = CGPoint(x: randomX, y: size.height)
    }

    // Move Opponent: Falls straight down from a random starting position at the top
    func moveOpponent() {
        resetOpponentPosition() // Ensure opponent starts at a new random X position

        // Random fall speed between 1 and 4 seconds
        let fallSpeed = Double.random(in: 1.0...4.0)
        let fallAction = SKAction.moveTo(y: 0, duration: fallSpeed) // Move opponent downward

        // Move opponent back up instantly when it reaches the bottom
        let resetAction = SKAction.run { self.resetOpponentPosition() }

        // Sequence: Fall -> Reset -> Repeat
        let movementSequence = SKAction.sequence([fallAction, resetAction, SKAction.run(moveOpponent)])

        opponentSprite.run(movementSequence)
    }

    // Collision Detection
    func didBegin(_ contact: SKPhysicsContact) {
        // Check if the opponent collides with the player
        if contact.bodyA.node == opponentSprite || contact.bodyB.node == opponentSprite {
            opponentSprite.removeAllActions() // Stop current movement
            opponentSprite.removeFromParent() // Remove opponent from scene
            
            // Respawn opponent at the top after a short delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.respawnOpponent()
            }
        }
    }

    // Respawn opponent with a new random position
    func respawnOpponent() {
        // Create a new opponent sprite
        opponentSprite = SKSpriteNode(imageNamed: "OpponentSprite")

        // Set opponent size
        opponentSprite.size = CGSize(width: 100, height: 100)

        // Assign physics properties
        opponentSprite.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        opponentSprite.physicsBody?.categoryBitMask = spriteCategory2
        opponentSprite.physicsBody?.contactTestBitMask = spriteCategory1
        opponentSprite.physicsBody?.collisionBitMask = spriteCategory1
        opponentSprite.physicsBody?.affectedByGravity = false
        opponentSprite.physicsBody?.isDynamic = true

        // Add opponent back to scene
        addChild(opponentSprite)

        // Restart opponent movement
        moveOpponent()
    }

    // Allow Player to Move Left and Right
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)

            // Allow only horizontal movement, keep Y fixed at bottom
            sprite.position = CGPoint(x: location.x, y: size.height * 0.1)
        }
    }

    // Default touch methods (not used but kept for reference)
    func touchDown(atPoint pos: CGPoint) {}
    func touchMoved(toPoint pos: CGPoint) {}
    func touchUp(atPoint pos: CGPoint) {
        sprite.run(SKAction.move(to: pos, duration: 1))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func update(_ currentTime: TimeInterval) {}
}

