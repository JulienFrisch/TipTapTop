//
//  Levels_Protocols.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/9/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import Foundation
import CoreMotion
import SpriteKit

protocol SixTeenTouchPads {
    
}

protocol EighteenTouchPads {
    func addTouchPads(progressBar: ProgressNode)
}

/**
 Gravity Protocol
 */
protocol Gravity {
    //we are going to use the motion manager to read the acceleremoter
    var motionManager: CMMotionManager { get }
    //we do not move the touchpad if the acceleration does not reach a certain threshold
    var accelerationThreshold: Double { get }
    //we define a mass that will influence the speed of our touchpads
    var touchpadMass: CGFloat { get }
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval, touchPads: [TouchPad])
    func addPhysicBody(touchPads: [TouchPad])
}

extension Gravity {
    
    func processUserMotionForUpdate(currentTime: CFTimeInterval, touchPads: [TouchPad]){
        //we retrieve the acceleromter data
        if let data = self.motionManager.accelerometerData{
            //we do not move the touchpad if the acceleration value does not reach a certain threshold
            if sqrt(pow(data.acceleration.x,2) + pow(data.acceleration.y,2)) > self.accelerationThreshold {
                //we create a vector
                let force = CGVectorMake(CGFloat(data.acceleration.x), CGFloat(data.acceleration.y))
                for touchpad in touchPads{
                    touchpad.physicsBody!.applyForce(force)
                }
            }
        }
    }
    
    func addPhysicBody(touchPads: [TouchPad]){
        for touchpad in touchPads{
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
}

