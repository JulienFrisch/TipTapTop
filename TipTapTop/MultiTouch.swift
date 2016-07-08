//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class MultiTouch: BaseGameScene {
    /**
    We load a different 18 touchpads instead of 8
    */
    override func addTouchPads(progressBar: ProgressNode){
        let deltaX = self.frame.size.width / 6
        let deltaY = (self.frame.size.height - progressBar.height - 2 * self.progressBarVerticalIntervalSpace) / 12
        for xi in 0...2 {
            for yi in 0...5 {
                let x = deltaX * (1.0 + CGFloat(xi) * 2.0)
                let y = deltaY * (1.0 + CGFloat(yi) * 2.0)
                let touchpad = TouchPad.createAtPosition(CGPointMake(x, y), radius: 50.0)
                self.addChild(touchpad)
                self.touchPads.append(touchpad)
            }
            
        }
    }
}

class MultiTouch_Easy: MultiTouch {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
    
}

class MultiTouch_Hard: MultiTouch {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
    
}