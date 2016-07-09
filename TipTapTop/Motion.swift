//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit
import CoreMotion

class Motion: BaseGameScene {
    //MARK: Motion Manager variables
    
    //we are going to use the motion manager to read the acceleremoter
    let motionManager: CMMotionManager = CMMotionManager()
    //we do not move the touchpad if the acceleration does not reach a certain threshold
    let accelerationThreshold = 0.2
    let touchpadMass:CGFloat = 0.005
    
    
    //MARK: Overrided functions
    
    /**
    We start the accelerometer
    */
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        //we also add a physicBody to our scene so the touchpads won't "fall"
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.motionManager.startAccelerometerUpdates()
    }
    
    /**
    We want an update from motion manager only during the scene update phase
    */
    override func update(currentTime: CFTimeInterval) {
        super.update(currentTime)
        self.processUserMotionForUpdate(currentTime)
    }
    
    /**
    we stop the accelerometer after a win
    */
    override func performWin() {
        super.performWin()
        self.motionManager.stopAccelerometerUpdates()
    }
    
    /**
    We stop the acceleremoter after losing
    */
    override func performGameOver() {
        super.performGameOver()
        self.motionManager.stopAccelerometerUpdates()
    }
    
    /**
    We add physics to our touchpads
    */
    override func addTouchPads(progressBar: ProgressNode) {
        super.addTouchPads(progressBar)
        for touchpad in self.touchPads{
            //we create the touchpad physic body
            touchpad.physicsBody = SKPhysicsBody(circleOfRadius: touchpad.frame.size.width / 2)
            //we confirm the touchpad physic body is affected by the laws of physics
            touchpad.physicsBody?.dynamic = true
            //not by gravity (we will apply a custom force later)
            touchpad.physicsBody!.affectedByGravity = false
            //we assign it a mass
            touchpad.physicsBody?.mass = self.touchpadMass
        }
    }
    
    //MARK: Helper Methods
    
    /**
    Function to move all the touchpads with the motion manager
    */
    func processUserMotionForUpdate(currentTime: CFTimeInterval) {
        //we retrieve the acceleromter data
        if let data = motionManager.accelerometerData{
            //we do not move the touchpad if the acceleration value does not reach a certain threshold
            if sqrt(pow(data.acceleration.x,2) + pow(data.acceleration.y,2)) > self.accelerationThreshold {
                //we create a vector
                let force = CGVectorMake(CGFloat(data.acceleration.x), CGFloat(data.acceleration.y))
                for touchpad in self.touchPads{
                    touchpad.physicsBody!.applyForce(force)
                }
            }
        }
    }
}

class Motion_Easy: Motion {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
    
}

class Motion_Hard: Motion {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
    
}