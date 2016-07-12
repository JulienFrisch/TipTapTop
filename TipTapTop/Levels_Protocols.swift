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

//MARK: Different TouchPoints map
protocol EighteenTouchPads {
    func addEighteenTouchPads(progressBar: ProgressNode, scene: BaseGameScene)
}

extension EighteenTouchPads {
    func addEighteenTouchPads(progressBar: ProgressNode, scene: BaseGameScene){
        let deltaX = scene.frame.size.width / 6
        let deltaY = (scene.frame.size.height - progressBar.height - 2 * scene.progressBarVerticalIntervalSpace) / 12
        for xi in 0...2 {
            for yi in 0...5 {
                let x = deltaX * (1.0 + CGFloat(xi) * 2.0)
                let y = deltaY * (1.0 + CGFloat(yi) * 2.0)
                let touchpad = TouchPad.createAtPosition(CGPointMake(x, y), radius: min(deltaX,deltaY) * 0.90)
                scene.addChild(touchpad)
                scene.touchPads.append(touchpad)
            }
        }
    }
}

protocol EightTouchPads {
    func addEightTouchPads(progressBar: ProgressNode, scene: BaseGameScene)
}

extension EightTouchPads {
    func addEightTouchPads(progressBar: ProgressNode, scene: BaseGameScene){
        let deltaX = scene.frame.size.width / 4
        let deltaY = (scene.frame.size.height - progressBar.height - 2 * scene.progressBarVerticalIntervalSpace) / 8
        for i in 0...7 {
            let x = deltaX * CGFloat(1 + (i % 2) * 2)
            let y = deltaY * CGFloat(1 + i - i % 2)
            let touchpad = TouchPad.createAtPosition(CGPointMake(x, y), radius: min(deltaX,deltaY) * 0.90)
            scene.addChild(touchpad)
            scene.touchPads.append(touchpad)
        }
    }
}

protocol ThreeBigSixSmallTouchPads {
    func addThreeBigSixSmallTouchPads(progressBar: ProgressNode, scene: BaseGameScene)
}

extension ThreeBigSixSmallTouchPads {
    func addThreeBigSixSmallTouchPads(progressBar: ProgressNode, scene: BaseGameScene){
        let deltaX = scene.frame.size.width / 6
        let deltaY = (scene.frame.size.height - progressBar.height - 2 * scene.progressBarVerticalIntervalSpace) / 12
        
        //first we put the "Big" touchpads
        let bigPos: [CGPoint] = [CGPointMake(2 * deltaX, 2 * deltaY),
                                 CGPointMake(4 * deltaX, 6 * deltaY),
                                 CGPointMake(2 * deltaX, 10 * deltaY)]
        for position in bigPos {
            let bigTouchPad = TouchPad.createAtPosition(position, radius:  2 * min(deltaX, deltaY) * 0.95)
            scene.addChild(bigTouchPad)
            scene.touchPads.append(bigTouchPad)
        }
        
        //Now the "Small" touchpads
        let smallPos: [CGPoint] = [CGPointMake(5 * deltaX, deltaY),
                                   CGPointMake(5 * deltaX, 3 * deltaY),
                                   CGPointMake(5 * deltaX, 9 * deltaY),
                                   CGPointMake(5 * deltaX, 11 * deltaY),
                                   CGPointMake(deltaX, 5 * deltaY),
                                   CGPointMake(deltaX, 7 * deltaY)]
        for position in smallPos {
            let smallTouchPad = TouchPad.createAtPosition(position, radius: min(deltaX, deltaY) * 0.95)
            scene.addChild(smallTouchPad)
            scene.touchPads.append(smallTouchPad)
        }
    }
}

//MARK: Added properties to GameScene

/**
 Enable Gravity features in the GameScene
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
            }
        }
    }
}

/**
 Enable the locking of a touchpad in the game scene
 */
protocol Lock: class {
    //We define a dedicated array of touchpads to store those which are locked
    var lockedTouchPads: [TouchPad] { get set }
    func lock(touchpad: TouchPad)
    func unlock(touchpad: TouchPad)
}

extension Lock {
    /**
    We turn on a selected touchpadd and add it to the list of locked touch pads
    */
    func lock(touchpad: TouchPad){
        //touchpad.turnOn(currentTime)
        lockedTouchPads.append(touchpad)
    }
    
    /**
     We remove a touchpad from the list of locked touch pads (we do not turn it off)
     */
    func unlock(touchpad: TouchPad){
        if let index = self.lockedTouchPads.indexOf(touchpad){
            lockedTouchPads.removeAtIndex(index)
        }
    }
}

