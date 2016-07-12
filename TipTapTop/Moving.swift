//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class Moving: BaseGameScene, EighteenTouchPads, Moveable {
    //MARK: Overrided functions
    
    /**
     We start moving
     */
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.moveTouchPad(self.touchPads[0], time: 3.0, points: [self.touchPads[12].position,self.touchPads[14].position, self.touchPads[2].position, self.touchPads[0].position], loops: -1)
    }
    
    /**
    We load a different 18 touchpads instead of 8
    */
    override func addTouchPads(progressBar: ProgressNode){
        //we use our EighteenTouchPads protocol
        self.addEighteenTouchPads(progressBar, scene: self)
    }
}

class Moving_Easy: Moving {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
    
}

class Moving_Hard: Moving {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
    
}