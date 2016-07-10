//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class BigsAndSmalls: BaseGameScene, ThreeBigSixSmallTouchPads {
    /**
    We load a three big and six small touchpads instead of 8 regular
    */
    override func addTouchPads(progressBar: ProgressNode){
        //we use our ThreeBigSixSmallTouchPads protocol
        self.addThreeBigSixSmallTouchPads(progressBar, scene: self)
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