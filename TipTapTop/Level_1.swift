//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class Level_1: BaseGameScene {
    
    override func didMoveToView(view: SKView){
        //We suse a different level name to load different settings
        self.levelName = "Level_1"
        super.didMoveToView(view)
    }
    

}
