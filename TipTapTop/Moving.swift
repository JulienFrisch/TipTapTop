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
        //we create a set of moves for the bottom touchpads
        for (x,y) in [(0,0),(1,0)] {
            if let currentIndex = self.index(x: x, y: y),
                let p1Index = self.index(x: 2, y: 0),
                let p2Index = self.index(x: 2, y: 2),
                let p3Index = self.index(x: 0, y: 2),
                let p4Index = self.index(x: 0, y: 0){
                let points = [touchPads[p1Index].position, touchPads[p2Index].position, touchPads[p3Index].position, touchPads[p4Index].position, touchPads[currentIndex].position]
                self.moveTouchPad(touchPads[currentIndex], time: 30.0, points: points, loops: -1)
            }
        }
        for (x,y) in [(2,0),(2,1)] {
            if let currentIndex = self.index(x: x, y: y),
                let p1Index = self.index(x: 2, y: 2),
                let p2Index = self.index(x: 0, y: 2),
                let p3Index = self.index(x: 0, y: 0),
                let p4Index = self.index(x: 2, y: 0){
                let points = [touchPads[p1Index].position, touchPads[p2Index].position, touchPads[p3Index].position, touchPads[p4Index].position, touchPads[currentIndex].position]
                self.moveTouchPad(touchPads[currentIndex], time: 30.0, points: points, loops: -1)
            }
        }
        for (x,y) in [(1,2),(2,2)] {
            if let currentIndex = self.index(x: x, y: y),
                let p1Index = self.index(x: 0, y: 2),
                let p2Index = self.index(x: 0, y: 0),
                let p3Index = self.index(x: 2, y: 0),
                let p4Index = self.index(x: 2, y: 2){
                let points = [touchPads[p1Index].position, touchPads[p2Index].position, touchPads[p3Index].position, touchPads[p4Index].position, touchPads[currentIndex].position]
                self.moveTouchPad(touchPads[currentIndex], time: 30.0, points: points, loops: -1)
            }
        }
            for (x,y) in [(0,1),(0,2)] {
                if let currentIndex = self.index(x: x, y: y),
                    let p1Index = self.index(x: 0, y: 0),
                    let p2Index = self.index(x: 2, y: 0),
                    let p3Index = self.index(x: 2, y: 2),
                    let p4Index = self.index(x: 0, y: 2){
                    let points = [touchPads[p1Index].position, touchPads[p2Index].position, touchPads[p3Index].position, touchPads[p4Index].position, touchPads[currentIndex].position]
                    self.moveTouchPad(touchPads[currentIndex], time: 30.0, points: points, loops: -1)
                }
        }
        
        //self.moveTouchPad(self.touchPads[0], time: 3.0, points: [self.touchPads[12].position,self.touchPads[14].position, self.touchPads[2].position, self.touchPads[0].position], loops: -1)
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