//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class BigsAndSmalls: BaseGameScene {
    /**
    We load a different 18 touchpads instead of 8
    */
    override func addTouchPads(progressBar: ProgressNode){
        let deltaX = self.frame.size.width / 6
        let deltaY = (self.frame.size.height - progressBar.height - 2 * self.progressBarVerticalIntervalSpace) / 12
        
        //first we put the "Big" touchpads
        let bigPos: [CGPoint] = [CGPointMake(2 * deltaX, 2 * deltaY),
                                 CGPointMake(4 * deltaX, 6 * deltaY),
                                 CGPointMake(2 * deltaX, 10 * deltaY)]
        for position in bigPos {
            let bigTouchPad = TouchPad.createAtPosition(position, radius:  2 * min(deltaX, deltaY) * 0.95)
            self.addChild(bigTouchPad)
            self.touchPads.append(bigTouchPad)
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
            self.addChild(smallTouchPad)
            self.touchPads.append(smallTouchPad)
        }
    }
}

class BigsAndSmalls_Easy: BigsAndSmalls {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
    
}

class BigsAndSmalls_Hard: BigsAndSmalls {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
    
}