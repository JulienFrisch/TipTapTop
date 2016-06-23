//
//  TouchPoint.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class TouchPoint: SKShapeNode {
    
    //MARK: Variables
    //TO-DO: Create a property of class file to store those values
    var on: Bool = false
    let radius: CGFloat = 20.0
    let neutralColor = UIColor.grayColor()
    let touchColor = UIColor.yellowColor()
    let warningColor = UIColor.redColor()
    var touched: Bool = false
    let timeLimit: NSTimeInterval = 5.0
    var lastTouched: NSTimeInterval = 0.0
    
    /**
    Create and return a touchpoint at a specified location
    */
    class func createAtPosition(position: CGPoint) -> TouchPoint{
        //we create the touchpoint
        let touchpoint = TouchPoint(circleOfRadius: 50.0)
        
        //we assume the touchpoint starts neutral
        touchpoint.fillColor = touchpoint.neutralColor
        
        //we enable user interaction
        touchpoint.userInteractionEnabled = true
        
        //we place it
        touchpoint.position = position
        touchpoint.zPosition = 10
        
        //we name it
        touchpoint.name = "TouchPoint"
        
        return touchpoint
    }
    
    //MARK: SKNode functions overrided
    
    /**
    if the touchpoint is touched, a set of actions are launched
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //we update the touched value
        self.touched = true
        self.lastTouched = event!.timestamp
        
        if self.on {
            self.turnOff()
        } else {
            self.turnOn()
        }
    }
    
    /**
    If the touchpoint is no longer touched, a set of actions are launched
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //we update the touched value
        self.touched = false
    }
    

    //MARK: Actions
    /**
    Turn the touchpoint on so it needsto be touched
    */
    func turnOn(){
        //we change the on variable
        self.on = true
        
        //we change the color
        self.fillColor = self.touchColor
    }
    
    /**
    Turn off the touchpoint so it does not need to be touched anymore
    */
    func turnOff(){
        //we change the off variable
        self.on = false
        
        //we chage the color
        self.fillColor = self.neutralColor
    }
    
    /**
    Update the color depending on the status of the touchpoint and whether or not it is being touched
    */
    func updateColor(currentTime: NSTimeInterval){
        
        //if the touchpoint is on but not touched
        if self.on && !self.touched {
            let progress = (currentTime - self.lastTouched) / self.timeLimit
            self.fillColor = self.touchColor.interpolateRGBColorTo(self.warningColor, fraction: CGFloat(progress))
        }
        
    }


}
