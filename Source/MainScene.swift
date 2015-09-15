import Foundation
import GameKit

class MainScene: CCNode {
    
    weak var ball: CCSprite!
    weak var paddle: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
//    weak var zombie: CCSprite!
    weak var zombies: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var comboLabel: CCLabelTTF!
    weak var gameOverScoreLabel: CCLabelTTF!
    weak var highscoreLabel: CCLabelTTF!
    weak var soundEffectsButtonText: CCLabelTTF!
    weak var musicButtonText: CCLabelTTF!
    
    var width = CCDirector.sharedDirector().viewSize().width
    var height = CCDirector.sharedDirector().viewSize().height
    var mainMenu = true
    var ballInScreen = false
    var buttonPressed = true
    var randomSpawn = CGFloat(3)
    var hundredScore = 0
    var interstitialAd = 3
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    var combo: Int = 0 {
        didSet {
            comboLabel.string = "x\(combo)"
        }
    }
    
    //OALSimpleAudio for sound
    let audio = OALSimpleAudio.sharedInstance()
    let defaults = NSUserDefaults.standardUserDefaults()
    let soundEffectsKey = "soundEffectsKey"
    let backgroundMusicKey = "backgroundMusicKey"
    
    func didLoadFromCCB() {
//        multipleTouchEnabled = true
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
//        gamePhysicsNode.debugDraw = true
        
        mainMenuAnimation()
        setUpGameCenter()
//        preloadSounds()
        
        if !defaults.boolForKey(soundEffectsKey) {
            soundEffectsButtonText.string = "ON"
        }
        
        if !defaults.boolForKey(backgroundMusicKey) {
            musicButtonText.string = "ON"
        }
        
        if defaults.boolForKey(soundEffectsKey) {
            preloadSounds()
        }
        
    }
    
    func soundEffectsToggle() {
        var currentState = defaults.boolForKey(soundEffectsKey)
        
        if currentState {
            defaults.setBool(false, forKey: soundEffectsKey)
            soundEffectsButtonText.string = "OFF"
        }
        else {
            defaults.setBool(true, forKey: soundEffectsKey)
            soundEffectsButtonText.string = "ON"
        }
    }
    
    func backgroundMusicToggle() {
        var currentState = defaults.boolForKey(backgroundMusicKey)
        
        if currentState {
            defaults.setBool(false, forKey: backgroundMusicKey)
            musicButtonText.string = "OFF"
            audio.stopEverything()
        }
        else {
            defaults.setBool(true, forKey: backgroundMusicKey)
            musicButtonText.string = "ON"
        }
    }
    
    func preloadSounds() {
        //access audio object
//        var hitSound: OALSimpleAudio = OALSimpleAudio.sharedInstance()
        
        //preload the audio
        audio.preloadEffect("CRUNCH_sound.mp3")
//        audio.preloadEffect("realisticPunchMarkDiAngelo.mp3")
        println("sounds loaded")
    }
    
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
    
    func openGameCenter() { 
        showLeaderboard()
    }
    
    func mainMenuAnimation() {
        animationManager.runAnimationsForSequenceNamed("MainMenu")
    }
    
    func play() {
        if buttonPressed == true{
            animationManager.runAnimationsForSequenceNamed("GameStart")
            buttonPressed = false
        }
        mainMenu = false
        ballPush()
        
        if defaults.boolForKey(backgroundMusicKey) {
            audio.playBg("BackgroundMusic2.wav", loop: true) //http://www.flashkit.com/loops/Rap/Urban/alley-130626224514.html
        }
        
        iAdHandler.sharedInstance.displayBannerAd()
    }
    
    func settings() {
        animationManager.runAnimationsForSequenceNamed("Settings")
    }
    
    func settingsBack() { //currently a bit buggy . might get rid of settings button in restart timeline
        animationManager.runAnimationsForSequenceNamed("SettingsBack")

//        animationManager.runAnimationsForSequenceNamed("MainMenu")
    }
    
    func aboutTheGame() {
        animationManager.runAnimationsForSequenceNamed("AboutTheGame")
    }
    
    func backToSettings() {
        animationManager.runAnimationsForSequenceNamed("BackToSettings")
    }
    
    func tip() {
        animationManager.runAnimationsForSequenceNamed("TipsAndTricks")
    }
    
    func tipsToSettings() {
        animationManager.runAnimationsForSequenceNamed("TipsToSettings")
    }
    
    func backToMainMenu() {
        mainMenu = true
        zombies.removeAllChildren()
        hundredScore = 0
        score = 0
        randomSpawn = 3
        
        animationManager.runAnimationsForSequenceNamed("BackToMain")
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
        zombie.scale = 0.1
        
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
        scheduleOnce("comboHits", delay: 0.01)
        
//        var hitSound: OALSimpleAudio = OALSimpleAudio.sharedInstance()
        if defaults.boolForKey(soundEffectsKey) {
//            audio.playEffect("realisticPunchMarkDiAngelo.mp3")
            audio.playEffect("CRUNCH_sound.mp3") //http://www.flashkit.com/soundfx/Cartoon/Crunches/CRUNCH_I-Intermed-566/index.php
        }
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, paddle: CCNode!, zombie: CCNode!) -> ObjCBool {
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, zombie: CCNode!, invisibleWall: CCNode!) -> ObjCBool {
        if ballInScreen == true {
            scheduleOnce("gameOver", delay: 0.2)
        }
        zombie.removeFromParent()
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, invisibleWall: CCNode!) -> ObjCBool {
        
        return false
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, ball: CCNode!, paddle: CCNode!) -> ObjCBool {
        
        scheduleOnce("womboCombos", delay: 0.01)
        
        return true
    }
    
    func comboHits() {
        let pos = ball.position
        let pad = paddle.position
        combo++
        animationManager.runAnimationsForSequenceNamed("comboLabel")
        ball.position = pos
        paddle.position = pad
    }
    
    func womboCombos() {
        //stores position b/c the following animations reset the ball&pad positions
        let pos = ball.position
        let pad = paddle.position
        if combo >= 20 && combo < 30 {
            animationManager.runAnimationsForSequenceNamed("Mega Kill")
            println("Mega Kill")
        } else if combo >= 30 && combo < 50 {
            animationManager.runAnimationsForSequenceNamed("Killing Spree")
            println("Killing Spree")
        } else if combo >= 50 && combo < 70 {
            animationManager.runAnimationsForSequenceNamed("Rampage")
            println("Rampage")
        } else if combo >= 70 && combo < 100 {
            animationManager.runAnimationsForSequenceNamed("Obliteration")
            println("Obliteration")
        } else if combo >= 100 {
            animationManager.runAnimationsForSequenceNamed("Zombie Genocide")
            println("Zombie Genocide")
        }
        //ball/pad positions are then using stored positions from before
        ball.position = pos
        paddle.position = pad
        combo = 0
    }
    
    func gameOver() {
        animationManager.runAnimationsForSequenceNamed("GameOver")
//        mainMenu = true
        ballInScreen = false
        buttonPressed = true
        combo = 0
        gameOverScoreLabel.string = "\(score)"
        
        //highscore code
        let defaults = NSUserDefaults.standardUserDefaults()
        var highscore = defaults.integerForKey("highscore")
        //set highscore to gamecenter
        GameCenterInteractor.sharedInstance.saveHighScore(Double(highscore))
        if score > highscore {
            defaults.setInteger(score, forKey: "highscore")
        }
        
        //set highscore
        var newHighscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        highscoreLabel.string = "\(newHighscore)"
        
        //interstitial ad occurence
        if interstitialAd == 4 {
            iAdHandler.sharedInstance.displayInterstitialAd()
            interstitialAd = 0
        }
    }
    
    func restart() {
        zombies.removeAllChildren()
        if buttonPressed == true {
            animationManager.runAnimationsForSequenceNamed("Restart")
            buttonPressed = false
        }

        ballPush()
        mainMenu = false
        hundredScore = 0
        score = 0
        randomSpawn = 3
        interstitialAd++
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
//        println(ball.physicsBody.velocity)
        
        //ball particle thingy code - CRUNCH TIME
        var velX = ball.physicsBody.velocity.x
        var velY = ball.physicsBody.velocity.y
        var theta = atan2(velX, velY)
        var degrees = (Double (theta) / Double(M_PI)) * 180
        var rotate = degrees + 180
        
        ball.rotation = Float(rotate)
        
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

// MARK: Game Center Handling
extension MainScene: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    
    // Delegate methods
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}