import Foundation

class MainScene: CCNode {
    
    weak var ball: CCSprite!
    weak var paddle: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
<<<<<<< HEAD
    weak var zombie: CCSprite!
    
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    var mainMenu = true
    var ballInScreen = false
=======
    
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
>>>>>>> a2549433925b7b5b6d9172538b9e8efcf77b2ec6
    
    func didLoadFromCCB() {
        //multipleTouchEnabled = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
<<<<<<< HEAD
        
        animationManager.runAnimationsForSequenceNamed("MainMenu")
    }
    
    func play() {
        animationManager.runAnimationsForSequenceNamed("GameStart")
        ballPush()
        mainMenu = false
    }
    
    func ballPush() {
        var pushX = CGFloat(arc4random_uniform(201)) - 100
=======
    }
    
    func ballPush() {
        var pushX = CGFloat(arc4random_uniform(201) - 100)
>>>>>>> a2549433925b7b5b6d9172538b9e8efcf77b2ec6
        var pushY = CGFloat(200)
        
        ball.physicsBody.velocity.x = pushX
        ball.physicsBody.velocity.y = pushY
    }
    
<<<<<<< HEAD
    func ballTrue() {
        ballInScreen = true
    }
    
=======
>>>>>>> a2549433925b7b5b6d9172538b9e8efcf77b2ec6
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
    
<<<<<<< HEAD
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, zombie: CCNode!) -> ObjCBool {
        
        
        return false
    }
    
    override func update(delta: CCTime) {
        if ball.position.y < 0 && ballInScreen == true {
            println("GameOver")
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if mainMenu == false {
            var touchX = touch.locationInNode(CCPhysicsNode()!).x
            paddle.positionInPoints.x = touchX
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if mainMenu == false {
            var touchX = touch.locationInNode(CCPhysicsNode()!).x
            paddle.positionInPoints.x = touchX
        }
=======
    override func update(delta: CCTime) {
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
>>>>>>> a2549433925b7b5b6d9172538b9e8efcf77b2ec6
    }
}
