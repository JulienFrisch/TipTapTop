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
    func shake(touchPads: [TouchPad])
    func retrieveVector() -> CGVector?
}

extension Gravity {
    
    /**
    Retrieve the phone position and moves touchpads accordingly
    */
    func processUserMotionForUpdate(currentTime: CFTimeInterval, touchPads: [TouchPad]){
        //we retrieve the vector to be used
        let vector = self.retrieveVector()
        //we unwrap it
        if let vector = vector{
            //we do not move the touchpad if the acceleration value does not reach a certain threshold
            if sqrt(pow(Double(vector.dx),2) + pow(Double(vector.dy),2)) > self.accelerationThreshold {
                for touchpad in touchPads{
                    touchpad.physicsBody?.applyForce(vector)
                }
            }
        }
    }
    
    /**
    Assign a physic body to a set of touchpads
    */
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
    
    /**
    Retrieve the force to be applied to a touchpad absed on the phone position
    */
    func retrieveVector() -> CGVector?{
        var vector: CGVector?
        //we retrieve the acceleromter data
        if let data = self.motionManager.accelerometerData{
            //we create a vector
            vector = CGVectorMake(CGFloat(data.acceleration.x), CGFloat(data.acceleration.y))
        }
        return vector
    }
    
    
    
    /**
    Apply an opposite force to a set of touchpads
    */
    func shake(touchpads: [TouchPad]){
        //we retrieve the force currently applied by phone position and use its opposite
        let currentVector = self.retrieveVector()
        if let currentVector = currentVector{
            let oppositeVector = CGVectorMake(-currentVector.dx * 50, -currentVector.dy * 50)
            for touchpad in touchpads{
                //we add a little bit of randomness
                let randomX = CGFloat(drand48()) * 20.0 - 10.0
                let randomY = CGFloat(drand48()) * 20.0 - 10.0
                let oppositeRandomVector = CGVectorMake(oppositeVector.dx + randomX, oppositeVector.dy + randomY)
                touchpad.physicsBody?.applyForce(oppositeRandomVector)
                print("Force applied:\(oppositeRandomVector.dx);\(oppositeRandomVector.dy)")
            }


        }
    }

}

