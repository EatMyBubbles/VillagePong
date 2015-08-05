import Foundation

class MainScene: CCNode {
    
    weak var ball: CCSprite!
    weak var paddle: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    
    func didLoadFromCCB() {
        //multipleTouchEnabled = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
    }
    
    func ballPush() {
        var pushX = CGFloat(arc4random_uniform(201) - 100)
        var pushY = CGFloat(200)
        
        ball.physicsBody.velocity.x = pushX
        ball.physicsBody.velocity.y = pushY
    }
    
    func spawnZombie() {
        var spawnY = CGFloat(0.8 * height)
        var xCoor = CGFloat(arc4random_uniform(3))
        var zombie = CCBReader.load("Zombie") as! Zombie
        
        if xCoor == 0 {
            zombie.position.x = 0.2 * width
        }
        else if xCoor == 1 {
            zombie.position.x = 0.5 * width
        }
        else {
            zombie.position.x = 0.8 * width
        }
        zombie.position.y = spawnY
        
        gamePhysicsNode.addChild(zombie)
    }
    
    override func update(delta: CCTime) {
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
}
