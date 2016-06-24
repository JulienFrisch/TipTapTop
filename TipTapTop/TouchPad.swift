//
//  TouchPoint.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class TouchPad: SKShapeNode {
    
    //MARK: Variables
    //TO-DO: Create a property of class file to store those values
    var on: Bool = false
    static let radius: CGFloat = 75.0
    let neutralColor = UIColor.grayColor()
    let touchColor = UIColor.yellowColor()
    let warningColor = UIColor.redColor()
    var touched: Bool = false
    let timeLimit: NSTimeInterval = 5.0
    var lastTouched: NSTimeInterval = 0.0
    
    /**
    Create and return a touchpad at a specified location
    */
    class func createAtPosition(position: CGPoint) -> TouchPad{
        //we create the touchpad
        let touchpad = TouchPad(circleOfRadius: TouchPad.radius)
        
        //we assume the touchpoint starts neutral
        touchpad.fillColor = touchpad.neutralColor
        
        //we enable user interaction
        touchpad.userInteractionEnabled = true
        
        //we place it
        touchpad.position = position
        touchpad.zPosition = 10
        
        //we name it
        touchpad.name = "TouchPoint"
        
        return touchpad
    }
    
    //MARK: SKNode functions overrided
    
    /**
    if the touchpoint is touched, a set of actions are launched
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //we update the touched value
        self.touched = true
        let currentTime = event!.timestamp
        
        if self.on {
            //we re-initiate the turnOn
            self.turnOn(currentTime)
        } else {
            print("touching when not required")
        }
    }
    
    /**
    If the touchpad is no longer touched, a set of actions are launched
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //we update the touched value
        self.touched = false
        print("touches End")
    }
    

    //MARK: Actions
    /**
    Turn the touchpad on so it needsto be touched
    */
    func turnOn(currentTime: CFTimeInterval){
        //we change the on variable
        self.on = true
        
        //we update the lastTouched Variable
        self.lastTouched = currentTime
        
        //we change the color
        self.fillColor = self.touchColor
    }
    
    /**
    Turn off the touchpad so it does not need to be touched anymore
    */
    func turnOff(currentTime: CFTimeInterval){
        //we change the off variable
        self.on = false
        
        //we update the lastTouched Variable
        self.lastTouched = currentTime
        
        //we chage the color
        self.fillColor = self.neutralColor
    }
    
    /**
    Update the color depending on the status of the touchpad and whether or not it is being touched
    */
    func updateColor(currentTime: NSTimeInterval){
        
        //if the touchpoint is on but not touched
        if self.on && !self.touched {
            let progress = (currentTime - self.lastTouched) / self.timeLimit
            self.fillColor = self.touchColor.interpolateRGBColorTo(self.warningColor, fraction: CGFloat(progress))
        }
        
    }


}
