//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class MultiTouch: BaseGameScene, EighteenTouchPads {
    /**
    We load a different 18 touchpads instead of 8
    */
    override func addTouchPads(progressBar: ProgressNode){
        //we use our EighteenTouchPads protocol
        self.addEighteenTouchPads(progressBar, scene: self)
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