//
//  Level_1.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/7/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class BigSmallLocked: BaseGameScene, ThreeBigSixSmallTouchPads, Lock {
    //We define a dedicated array of touchpads to store those which are locked
    var lockedTouchPads = [TouchPad]()
    
    /**
     We load a three big and six small touchpads instead of 8 regular
     */
    override func addTouchPads(progressBar: ProgressNode){
        //we use our ThreeBigSixSmallTouchPads protocol
        self.addThreeBigSixSmallTouchPads(progressBar, scene: self)
        //based on the THreeBigSmallTouchPads protocol, the first three elements of touchpads should be "big"
        for index in 0...2 {
            self.lock(self.touchPads[index])
        }
        
        //TO-DO: retrieve current time in addTouchPads directly
//        //We run the update routine once, just to upload the current time
//        //not recommended
//        self.view.
//        //we retrieve the current time through unix timestamp
//        let currentTime = self.currentGameTime
//        //self.
//        print("Current time Locked:\(currentTime)")
//
//        
//        //based on the THreeBigSmallTouchPads protocol, the first three elements of touchpads should be "big"
//        for index in 0...2 {
//            self.lock(self.lockedTouchPads[index], currentTime: currentTime)
//        }
    }
    
    /** 
     We make sure the three big touchpads are all selected first at once
     we remove the locked buttons from the random switch mechanism
    */
    override func runRandomSwitch(touchPads: [TouchPad], maxTouchPadsActivated: Int, currentTime: NSTimeInterval) {
        //if the "Big" touchpads are not already on, we turn them all on
        if !self.lockedTouchPads[0].on || !self.lockedTouchPads[1].on || !self.lockedTouchPads[2].on {
            for touchpad in lockedTouchPads{
                touchpad.turnOn(currentTime)
            }
            //we play a switch sound
            self.runAction(self.switchSFX!)
            //no need to run the rest of the function
            return
        }
        
        
        //we select only the touchpads that do NOT belong to lockedTouchPads
        let unlockTouchPads: [TouchPad] = touchPads.filter({!self.lockedTouchPads.contains($0)})
        //we run the "usual" method on the remaining touchpads (and reduce the max number of touchpads, with 1 as minimum)
        super.runRandomSwitch(unlockTouchPads, maxTouchPadsActivated: max(maxTouchPadsActivated - lockedTouchPads.count,1), currentTime: currentTime)
    }
}

class BigSmallLocked_Easy: BigSmallLocked {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Easy"
        super.didMoveToView(view)
    }
    
}

class BigSmallLocked_Hard: BigSmallLocked {
    override func didMoveToView(view: SKView){
        //We use a different level name to load different settings
        self.levelConfigurationName = "Vanilla_Hard"
        super.didMoveToView(view)
    }
}
    