//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit
import CoreMotion

class Motion: BaseGameScene, Gravity, EightTouchPads {
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
        //we use our gravity protocol extension
        self.processUserMotionForUpdate(currentTime, touchPads: self.touchPads)
    }
    
    
    /**
    We add physics to our touchpads
    */
    override func addTouchPads(progressBar: ProgressNode) {
        //we use our EightTouchPads protocol
        self.addEightTouchPads(progressBar, scene: self)
        //we use our gravity protocol extension
        self.addPhysicBody(self.touchPads)
    }
    
    /**
    We shake the touchpads after each switch
    */
    override func runRandomSwitch(touchPads: [TouchPad], maxTouchPadsActivated: Int, currentTime: NSTimeInterval) {
        super.runRandomSwitch(touchPads, maxTouchPadsActivated: maxTouchPadsActivated, currentTime: currentTime)
        //we use our gravity protocol extension
        self.shake(touchPads)
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