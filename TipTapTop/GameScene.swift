//
//  GameScene.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright (c) 2016 Julien Frisch. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    //MARK: Scene variables
    var touchPads = [TouchPad]()
    //Time variables
    var lastUpdateTimeInterval:NSTimeInterval = 0.0
    var timeSinceLastSwitch: NSTimeInterval = 0.0
    var currentGameTime: NSTimeInterval = 0.0
    //Game Status
    var gameIsOver = false
    var readyForRestart = false
    var warning = false //define i the player is about to loose and a warning should be displayed
    var warning_1 = false
    var warning_2 = false
    var warning_3 = false
    //music
    var gameOverMusic = AVAudioPlayer()
    var gameOverMusicLoaded = false
    var gameWinMusic = AVAudioPlayer()
    var gameWinMusicLoaded = false
    
    //MARK: Configuration
    //Colors
    let backColor = UIColor(red: 225/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    //GamePlay Configuration
    let maxTouchPadsActivated = 4
    let initialSwitchTime: NSTimeInterval = 5.0
    let finalSwitchTime: NSTimeInterval = 1.5
    let maxGameTime: NSTimeInterval = 60 * 1
    let warningTimeAllocation: Double = 0.3 //how long before the limit must the alert starts (in %)
    
    //Progress bar
    //TO-DO: add progress bar to plist
    let progressBarVerticalIntervalSpace: CGFloat = 10.0
    
    //sound effects
    let switchSFX = SKAction.playSoundFileNamed("Switch.caf", waitForCompletion: false)
    let warningSFX = SKAction.playSoundFileNamed("Alert.caf", waitForCompletion: false)
    let pressStartSFX = SKAction.playSoundFileNamed("Touch.caf", waitForCompletion: false)
    
    
    //MARK: SKScene functions
    override func didMoveToView(view: SKView) {
        //we define the scene color
        self.backgroundColor = self.backColor
        
        //we add the progress bar
        let progressBar = ProgressNode.progressAtPosition(CGPointMake(0, self.frame.size.height - self.progressBarVerticalIntervalSpace), inFrame: self.frame) as ProgressNode
        self.addChild(progressBar)
        
        //we place 8 touchpoints, and add them to the touchpoints variable
        for i in 0...7 {
            let x = (self.frame.size.width / 4) * CGFloat(1 + (i % 2) * 2)
            let y = ((self.frame.size.height - progressBar.height - 2 * self.progressBarVerticalIntervalSpace) / 8) * CGFloat(1 + i - i % 2)
            let touchpad = TouchPad.createAtPosition(CGPointMake(x, y))
            self.addChild(touchpad)
            self.touchPads.append(touchpad)
        }
        
        //we prepare our musics
        //we add our music
        self.setupMusics()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.readyForRestart) { //we restart the game
            //we remove all the nodes
            for node: SKNode in self.children {
                node.removeFromParent()
            }
        
            //we make a small sound
            self.runAction(self.pressStartSFX){
                //once the sound is over, we reload the game with a new view
                let gameScene = GameScene(size: self.frame.size)
                self.view?.presentScene(gameScene)

            }


        
        }
    }

    override func update(currentTime: CFTimeInterval) {
        //we do not run the update function if the game is game over
        if !gameIsOver
        {
            //if the required game time is reached, the player wins
            if self.currentGameTime >= self.maxGameTime {
                self.performWin()
            } else{
                
                //we are going to store the process of the touchpad closest to the end
                var progressOldestTouchPad: Double = 0.0
                
                //we reinitiate our warning variale to 0
                self.warning = false
                
                //we update our touchPads and check they have been touched in time
                for touchpad in self.touchPads {
                    let touchedInTime = touchpad.updateTouchPad(currentTime)
                    //if a touchpad is not touched in time, we launch the game over
                    if !touchedInTime {
                        self.performGameOver()
                    }
                    //if any touchpad is in warning zone, we change the warning variable of the GameScene
                    if touchpad.computeProgress(currentTime) > (1 - self.warningTimeAllocation) {
                        self.warning = true
                        progressOldestTouchPad = max(touchpad.computeProgress(currentTime),progressOldestTouchPad)
                    }
                }
                
                //we update our time variables
                if (self.lastUpdateTimeInterval != 0){
                    self.timeSinceLastSwitch += currentTime - self.lastUpdateTimeInterval
                    self.currentGameTime += currentTime - self.lastUpdateTimeInterval
                }
                self.lastUpdateTimeInterval = currentTime
                
                //we compute the progress of the game and the associated switch time
                let progress: CGFloat = CGFloat(self.currentGameTime) / CGFloat(self.maxGameTime)
                let currentSwitchTime: NSTimeInterval = self.initialSwitchTime * (1 - Double(progress)) + self.finalSwitchTime * Double(progress)
                
                //we check if it is time to make a switch
                if (self.timeSinceLastSwitch > currentSwitchTime) {
                    //we run our random sequnce
                    runRandomSwitch(self.touchPads, maxTouchPadsActivated: self.maxTouchPadsActivated, currentTime: currentTime)
                    
                    //we update the time since we performed a switch
                    self.timeSinceLastSwitch = 0
                }
                
                //we update our progression bar
                //TO-DO: remove force unwrapping
                let progressionBar = self.childNodeWithName("ProgressNode") as! ProgressNode
                progressionBar.updateProgress((progress))
                
                //if the player is about to loose, we display a warning sound
                if self.warning{
                    self.displayWarning(progressOldestTouchPad)
                } else {
                    self.resetWarning()
                }

            }
        }

    }
    
    //MARK: Helper methods
    
    /**
    Run a random sequence of touchpad activations
    */
    func runRandomSwitch(touchPads: [TouchPad], maxTouchPadsActivated: Int, currentTime: NSTimeInterval){
        let activatedTouchPads = filterTouchPads(touchPads, on: true)
        let notActivatedTouchPads = filterTouchPads(touchPads, on: false)
        
        //if we have not reached the maxTouchPointsActivated, we just activate another touchpad
        if activatedTouchPads.count < maxTouchPadsActivated {
            randomTouchPad(notActivatedTouchPads).turnOn(currentTime)
            
        } else {
            //if we haven't, then weturn one activated touchpad off and activate another one
            randomTouchPad(activatedTouchPads).turnOff(currentTime)
            randomTouchPad(notActivatedTouchPads).turnOn(currentTime)
        }
        
        //we play a switch sound
        self.runAction(self.switchSFX)
        
    }
    
    /**
    Filter a set of TouchPads to keep only the activated or not activated ones
    */
    func filterTouchPads(touchPads: [TouchPad], on: Bool)->[TouchPad]{
        var filteredTouchPads = [TouchPad]()
        for touchpad in touchPads {
            if touchpad.on == on {
                filteredTouchPads.append(touchpad)
            }
        }
        return filteredTouchPads
    }
    
    /**
    Randomly select a touchpoint among a set of touchpoints
    */
    func randomTouchPad(touchPads: [TouchPad]) -> TouchPad {
        let numberOfTouchPads = touchPads.count
        let i = Int(arc4random_uniform(UInt32(numberOfTouchPads)))
        return touchPads[i]
    }
    
    /**
    Game Over script
    */
    func performGameOver(){
        print("Player loses.")
        //we update the gameisover variable
        self.gameIsOver = true
        
        //we add a gameover label
        let gameOver = GameOverNode.gameOverAtPosition(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
        self.addChild(gameOver)
        
        //play game over animation
        gameOver.performAnimation()
        
        //play game over music
        if self.gameOverMusicLoaded{
            self.gameOverMusic.play()
        }
        
        //get ready for restart
        self.readyForRestart = true

    }
    
    /**
    Win Script
     TEMPORARY, TO BE REWORKED
    */
    //TO-DO: Create another win routine when multiple levels are ready
    //TO-DO: refactor game-over
    func performWin(){
        print("Player wins.")
        //we update the gameisover variable
        self.gameIsOver = true
        
        //we add a win label
        let gameOverNode = GameOverNode.gameOverAtPosition(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
        
        //we manually retrieve the label node and update it
        let gameOverLabel = gameOverNode.childNodeWithName("GameOverLabel") as! SKLabelNode
        gameOverLabel.text = "Congrats! You Win!"

        self.addChild(gameOverNode)
        
        //play game over animation
        gameOverNode.performAnimation()
        
        //play game win music
        if self.gameWinMusicLoaded{
            self.gameWinMusic.play()
        }
        
        //get ready for restart
        self.readyForRestart = true
    }
    
    /**
     Reset the warning variables to false
     */
    func resetWarning(){
        self.warning_1 = false
        self.warning_2 = false
        self.warning_3 = false
    }
    
    /**
     Display a warning sound depending on the progress and which warning has already been played
     Update the warning variables accordingly
     */
    func displayWarning(progress: Double){
        
        //we start by warning 3 so we do not replay already used warnings
        //warning 3
        if !self.warning_3 && (1 - progress) < self.warningTimeAllocation * (1/3) {
            print("alert 3")
            self.runAction(self.warningSFX)
            self.warning_3 = true
            self.warning_2 = true
            self.warning_1 = true
        }
        
        //warning 2
        else if !self.warning_2 && (1 - progress) < self.warningTimeAllocation * (2/3) {
            print("alert 2")
            self.runAction(self.warningSFX)
            self.warning_2 = true
            self.warning_1 = true
        }
        
        //warning 1
        else if !self.warning_1 && (1 - progress) < self.warningTimeAllocation {
            print("alert 1")
            self.runAction(self.warningSFX)
            self.warning_1 = true
        }
    }
    
    //TO-DO: Make setupMusics more efficient
    //TO-DO: Check wav ok format
    func setupMusics(){

        //first game over
        //we retrieve the url of the mp3
        let gameOverURL = NSBundle.mainBundle().URLForResource("GameOver", withExtension: "wav")
        //unwrap our url
        if let url = gameOverURL {
            do{
                //load the music
                try self.gameOverMusic = AVAudioPlayer.init(contentsOfURL: url)
                self.gameOverMusic.numberOfLoops = 0
                self.gameOverMusic.prepareToPlay()
                self.gameOverMusicLoaded = true
            } catch {
                print("Impossible to load \(url.absoluteString)")
            }
        } else {
            print("Impossible to find the game over music.")
        }
        
        //then game won
        //we retrieve the url of the mp3
        let gameWinURL = NSBundle.mainBundle().URLForResource("Win", withExtension: "wav")
        //unwrap our url
        if let url = gameWinURL {
            do{
                //load the music
                try self.gameWinMusic = AVAudioPlayer.init(contentsOfURL: url)
                self.gameWinMusic.numberOfLoops = 0
                self.gameWinMusic.prepareToPlay()
                self.gameWinMusicLoaded = true
            } catch {
                print("Impossible to load \(url.absoluteString)")
            }
        } else {
            print("Impossible to find the game win music.")
        }
        
        
    }
}
