import Foundation

class MainScene: CCNode {
    
    weak var ball: CCSprite!
    weak var paddle: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
//    weak var zombie: CCSprite!
    weak var zombies: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var gameOverScoreLabel: CCLabelTTF!
    weak var highscoreLabel: CCLabelTTF!
    
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    var mainMenu = true
    var ballInScreen = false
    var zombieEnd = false
    var randomSpawn = CGFloat(3)
    var hundredScore = 0
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    func didLoadFromCCB() {
        //multipleTouchEnabled = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
//        gamePhysicsNode.debugDraw = true
        
        animationManager.runAnimationsForSequenceNamed("MainMenu")
        
    }
    
    func play() {
        animationManager.runAnimationsForSequenceNamed("GameStart")
        mainMenu = false
        ballPush()
        
        iAdHandler.sharedInstance.displayBannerAd()
    }
    
    func ballPush() {
        var pushX = CGFloat(arc4random_uniform(201)) - 100
        var pushY = CGFloat(200)
        
        ball.physicsBody.velocity.x = pushX
        ball.physicsBody.velocity.y = pushY
    }
    
    func ballTrue() {
        ballInScreen = true
    }
    
    func spawnZombie() {
        var spawnY = CGFloat(0.8 * height)
        var xCoor = CGFloat(arc4random_uniform(3))
        var zombie = CCBReader.load("Zombie") as! Zombie
        var xSpeed = CGFloat(arc4random() % 2)
        
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
        
        zombies.addChild(zombie)
        
        if xSpeed == 0 {
            zombie.physicsBody.velocity.x = 5
        }
        else {
            zombie.physicsBody.velocity.x = -5
        }
        zombie.physicsBody.velocity.y = -10
    }
    
//    func spawnZombieTimer() {
//        schedule("spawnZombie", interval: 1)
//    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, zombie: CCNode!) -> ObjCBool {
        zombie.removeFromParent()
        score++
        hundredScore++
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, paddle: CCNode!, zombie: CCNode!) -> ObjCBool {
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, zombie: CCNode!, invisibleWall: CCNode!) -> ObjCBool {
        if ballInScreen == true {
            scheduleOnce("gameOver", delay: 0.2)
        }
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, invisibleWall: CCNode!) -> ObjCBool {
        
        return false
    }
    
    func gameOver() {
        animationManager.runAnimationsForSequenceNamed("GameOver")
//        mainMenu = true
        ballInScreen = false
        gameOverScoreLabel.string = "\(score)"
        
        //highscore code
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
        }
        
        //set highscore
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highscoreLabel.string = "\(newHighscore)"
        
//        iAdHandler.sharedInstance.displayInterstitialAd()
        }
    
    func restart() {
        zombies.removeAllChildren()
        animationManager.runAnimationsForSequenceNamed("Restart")

        ballPush()
        mainMenu = false
        hundredScore = 0
        score = 0
        randomSpawn = 3
    }
    
    override func onEnter() {
        super.onEnter()
        iAdHandler.sharedInstance.loadAds(bannerPosition: .Top)
        iAdHandler.sharedInstance.loadInterstitialAd()
    }
    
    override func update(delta: CCTime) {
        if ball.position.y < 0 && ballInScreen == true {
            gameOver()
            println("GameOver")
        }
        
        var interval = CGFloat(arc4random_uniform(100))
        if interval <= randomSpawn && mainMenu == false {
            spawnZombie()
        }
        if hundredScore == 25 {
            hundredScore = 0
            randomSpawn++
        }
//        println(hundredScore)
//        println(randomSpawn)
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if mainMenu == false && ballInScreen == true {
            var touchX = touch.locationInNode(CCPhysicsNode()!).x
            paddle.positionInPoints.x = touchX
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if mainMenu == false && ballInScreen == true {
            var touchX = touch.locationInNode(CCPhysicsNode()!).x
            paddle.positionInPoints.x = touchX
        }
    }
}
