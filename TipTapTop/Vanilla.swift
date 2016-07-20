//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class Vanilla: BaseGameScene, EightTouchPads{
    /**
     We load a 8 touchpads
     */
    override func addTouchPads(progressBar: ProgressNode){
        //we use our EightTouchPads protocol
        self.addEightTouchPads(progressBar, scene: self)
    }
}

class Vanilla_Easy: Vanilla {
    
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
}

class Vanilla_Hard: Vanilla {
    
    override func didMoveToView(view: SKView){
        //We suse a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
}
