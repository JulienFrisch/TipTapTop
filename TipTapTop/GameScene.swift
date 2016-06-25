//
//  GameScene.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright (c) 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //TO-D: put variables values in a class or properties file

    //Scene variables
    var touchPads = [TouchPad]()
    let backColor = UIColor.cyanColor()
    
    //GamePlay Configuration
    let maxTouchPadsActivated = 4
    let switchTime: NSTimeInterval = 5.0
    let maxGameTime: NSTimeInterval = 20

    
    //Time tracking variables
    var lastUpdateTimeInterval:NSTimeInterval = 0.0
    var timeSinceLastSwitch: NSTimeInterval = 0.0
    var currentGameTime: NSTimeInterval = 0.0
    
    //Game Status
    var gameIsOver = false
    var readyForRestart = false
    
    //Progress bar
    let progressBarVerticalIntervalSpace: CGFloat = 10.0
    
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
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    if (self.readyForRestart) { //we restart the game
        //we remove all the nodes
        for node: SKNode in self.children {
            node.removeFromParent()
        }
        
        //we load a new view
        let gameScene = GameScene(size: self.frame.size)
        self.view?.presentScene(gameScene)
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
                //we update our touchPads and check they have been touched in time
                for touchpad in self.touchPads {
                    let touchedInTime = touchpad.updateTouchPad(currentTime)
                    //if a touchpad is not touched in time, we launch the game over
                    if !touchedInTime {
                        self.performGameOver()
                    }
                }
                
                //we update our time variables
                if (self.lastUpdateTimeInterval != 0){
                    self.timeSinceLastSwitch += currentTime - self.lastUpdateTimeInterval
                    self.currentGameTime += currentTime - self.lastUpdateTimeInterval
                }
                self.lastUpdateTimeInterval = currentTime
                
                //we check if it is time to make a switch
                if (self.timeSinceLastSwitch > self.switchTime) {
                    //we run our random sequnce
                    runRandomSwitch(self.touchPads, maxTouchPadsActivated: self.maxTouchPadsActivated, currentTime: currentTime)
                    
                    //we update the time since we performed a switch
                    self.timeSinceLastSwitch = 0
                }
                
                //we update our progression bar
                //TO-DO: remove force unwrapping
                let progressionBar = self.childNodeWithName("ProgressNode") as! ProgressNode
                progressionBar.updateProgress((CGFloat(self.currentGameTime) / CGFloat(self.maxGameTime)))

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
        print("Player looses.")
        //we update the gameisover variable
        self.gameIsOver = true
        
        //we add a gameover label
        let gameOver = GameOverNode.gameOverAtPosition(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
        self.addChild(gameOver)
        
        //play game over animation
        gameOver.performAnimation()
        
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
        
        //get ready for restart
        self.readyForRestart = true
    }
}
