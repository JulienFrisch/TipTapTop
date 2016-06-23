//
//  GameScene.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright (c) 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var touchPoints = [TouchPoint]()
    
    
    override func didMoveToView(view: SKView) {
        //we place 8 touchpoints
        for i in 0...7 {
            let x = (self.frame.size.width / 4) * CGFloat(1 + (i % 2) * 2)
            let y = (self.frame.size.height / 8) * CGFloat(1 + i - i % 2)
            let touchpoint = TouchPoint.createAtPosition(CGPointMake(x, y))
            self.addChild(touchpoint)
            self.touchPoints.append(touchpoint)
        }
        //let firstTouchPoint = TouchPoint.createAtPosition(CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)))
        //self.addChild(firstTouchPoint)
        
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
        for touchpoint in self.touchPoints {
            touchpoint.updateColor(currentTime)
        }
        //let touchpoint = self.childNodeWithName("TouchPoint") as! TouchPoint
        //touchpoint.updateColor(currentTime)
    }
}
