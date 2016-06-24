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

    var touchPads = [TouchPad]()
    let maxTouchPadsActivated = 4
    
    //Time tracking variables
    let switchTime: NSTimeInterval = 5.0
    var lastUpdateTimeInterval:NSTimeInterval = 0.0
    var timeSinceLastSwitch: NSTimeInterval = 0.0
    
    //Game Status
    var gameIsOver = false
    
    //MARK: SKScene functions
    override func didMoveToView(view: SKView) {
        //we place 8 touchpoints, and add them to the touchpoints variable
        for i in 0...7 {
            let x = (self.frame.size.width / 4) * CGFloat(1 + (i % 2) * 2)
            let y = (self.frame.size.height / 8) * CGFloat(1 + i - i % 2)
            let touchpad = TouchPad.createAtPosition(CGPointMake(x, y))
            self.addChild(touchpad)
            self.touchPads.append(touchpad)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        //we do not run the update function if the game is game over
        if !gameIsOver
        {
            //we update our touchPads and check they have been touched in time
            for touchpad in self.touchPads {
                let touchedInTime = touchpad.updateTouchPad(currentTime)
                //if a touchpad is not touched in time, we launch the game over
                if !touchedInTime {
                    self.gameOver()
                }
            }
            
            //we update our time variables
            if (self.lastUpdateTimeInterval != 0){
                self.timeSinceLastSwitch += currentTime - self.lastUpdateTimeInterval
            }
            self.lastUpdateTimeInterval = currentTime
            
            //we check if it is time to make a switch
            if (self.timeSinceLastSwitch > self.switchTime) {
                //we run our random sequnce
                runRandomSwitch(self.touchPads, maxTouchPadsActivated: self.maxTouchPadsActivated, currentTime: currentTime)
                
                //we update the time since we performed a switch
                self.timeSinceLastSwitch = 0
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
    func gameOver(){
        self.gameIsOver = true
        print("Game Over")
    }
 
}
