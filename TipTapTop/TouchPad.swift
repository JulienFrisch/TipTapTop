//
//  TouchPoint.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class TouchPad: SKShapeNode {
    //TO-DO: Create a property of class file to store those values
    //TO-DO: when figger is slidding to the touchpad, it should behave like atouchbegans

    //MARK: Status Variables
    var on: Bool = false //to show if the touchpad is activated
    var touched: Bool = false
    var timeOut: Bool = false //to show if the touchPad has not been touched in time

    //Color and form Variables
    let neutralColorFill = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    let neutralColorStroke = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
    let touchColorFill = UIColor(red: 255/255, green: 255/255, blue: 0.0, alpha: 1.0)
    let touchColorStroke = UIColor(red: 255/255, green: 229/255, blue: 204/255, alpha: 1.0)
    let warningColorFill = UIColor(red: 255/255, green: 0.0, blue: 0.0, alpha: 1.0)
    let warningColorStroke = UIColor(red: 225/255, green: 0.0, blue: 0.0, alpha: 1.0)
    static let radius: CGFloat = 75.0

    //Time variables
    let timeLimit: NSTimeInterval = 4.0
    var lastTouched: NSTimeInterval = 0.0
    let alertTimeAllocation: Double = 0.5 //how long before the limit must the alert starts (in %)
    
    //Sound Effects
    let touchSFX = SKAction.playSoundFileNamed("Touch.caf", waitForCompletion: false)
    
    /**
    Create and return a touchpad at a specified location
    */
    class func createAtPosition(position: CGPoint) -> TouchPad{
        //we create the touchpad
        let touchpad = TouchPad(circleOfRadius: TouchPad.radius)
        
        //we assume the touchpoint starts neutral
        touchpad.fillColor = touchpad.neutralColorFill
        touchpad.strokeColor = touchpad.neutralColorStroke
        
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
        //if we are over our time limit, we disable all actions
        if !timeOut {
            
            //we update the touched value
            self.touched = true
            
            //we retrieve the Current Time
            let currentTime = event!.timestamp
            
            if self.on {
                
                //we re-initiate the turnOn
                self.turnOn(currentTime)
                
                //we play a sound effect
                self.runAction(self.touchSFX)
                
               //we reset the
                
            } else {
                print("touching when not required")
            }
            

        }

    }
    
    /**
    If the touchpad is no longer touched, a set of actions are launched
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //if the value touched is already false (in case of touch moved), we do nothing
        if self.touched{
            //we update the touched value
            self.touched = false
        
            //we update the lastTouched variable
            self.lastTouched = event!.timestamp
        }
    }
    
    /**
    if the finger slip and we are not touching the pad anymore, we must update it accordingly
    */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //at least one touch must be within the pad perimeter
        var touchPadTouched = false
        for touch in touches {
            //we retrieve the touch latest location
            let touchPoint: CGPoint = touch.locationInNode(self)
            //we check if it is still within the touchpad boundaryes
            //note: the anchor point of the node is centered
            if fabs(touchPoint.x) < (self.frame.size.width / 2) && fabs(touchPoint.y) < (self.frame.size.height / 2) {
                touchPadTouched = true
            }
        }
        //if at least on touce touches the touchpad
        if touchPadTouched{
            //we retrieve the Current Time
            self.lastTouched = event!.timestamp
            
            //if previously the touchpad was not touched
            if !self.touched {
                self.touchesBegan(touches, withEvent: event)
            }
        } else {
            self.touched  = false
        }
        
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
        self.fillColor = self.touchColorFill
        self.strokeColor = self.touchColorStroke
    }
    
    /**
    Turn off the touchpad so it does not need to be touched anymore
    */
    func turnOff(currentTime: CFTimeInterval){
        //we change the off variable
        self.on = false
        
        //we chage the color
        self.fillColor = self.neutralColorFill
        self.strokeColor = self.neutralColorStroke
    }
    
    /**
    Update the color depending on the status of the touchpad and whether or not it is being touched
     return false if the TouchPad has not been touched within the allocated time limit
    */
    func updateTouchPad(currentTime: NSTimeInterval) -> Bool {
        
        //if the touchpad is on but not touched and we are not over our time limit
        if self.on && !self.touched {
            let progress = computeProgress(currentTime)
            //if the touchpad has not been touched in time
            if progress > 1 {
                self.timeOut = true
                return false
            } else {
                //if we have some time left
                //we update the color
                self.fillColor = self.touchColorFill.interpolateRGBColorTo(self.warningColorFill, fraction: CGFloat(progress))
                self.strokeColor = self.warningColorStroke
                
                return true
            }

        } else {
            //if the touchpad is off or if the touchpad is currently touched, we return true
            return true
        }
    }
    
    /**
    Compute the the % of time spent for a touchpad to be touched
    */
    func computeProgress(currentTime: NSTimeInterval)-> Double{
        //if the touchpad is turned off, or currently touched, progress is 0
        if !self.on || self.touched
        {
            return 0.0
        } else{
            let progress = (currentTime - self.lastTouched) / self.timeLimit
            return progress
        }
    }
}
