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

    //MARK: Status Variables
    var on: Bool = false //to show if the touchpad is activated
    var touched: Bool = false
    var timeOut: Bool = false //to show if the touchPad has not been touched in time

    //Color and form Variables
    let neutralColor = UIColor.grayColor()
    let touchColor = UIColor.yellowColor()
    let warningColor = UIColor.redColor()
    static let radius: CGFloat = 75.0

    //Time variables
    let timeLimit: NSTimeInterval = 4.0
    var lastTouched: NSTimeInterval = 0.0
    let alertTimeAllocation: Double = 0.5 //how long before the limit must the alert starts (in %)
    
    //Sound Effects
    let touchSFX = SKAction.playSoundFileNamed("Touch.caf", waitForCompletion: false)
    let alertSFX = SKAction.playSoundFileNamed("Alert.caf", waitForCompletion: false)
    var alert_1 = false
    var alert_2 = false
    var alert_3 = false
    
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
                
                //we reset our time alerts
                self.resetAlert()
                
            } else {
                print("touching when not required")
            }
            

        }

    }
    
    /**
    If the touchpad is no longer touched, a set of actions are launched
    */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //we update the touched value
        self.touched = false
        
        //we update the lastTouched variable
        self.lastTouched = event!.timestamp
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
     return false if the TouchPad has not been touched within the allocated time limit
    */
    func updateTouchPad(currentTime: NSTimeInterval) -> Bool {
        
        //if the touchpad is on but not touched and we are not over our time limit
        if self.on && !self.touched {
            let progress = (currentTime - self.lastTouched) / self.timeLimit
            //if the touchpad has not been touched in time
            if progress > 1 {
                self.timeOut = true
                return false
            } else {
                //if we have some time left
                //we update the color
                self.fillColor = self.touchColor.interpolateRGBColorTo(self.warningColor, fraction: CGFloat(progress))
                
                //we check if we need to display an alert
                self.displayAlert(progress)
                
                
                return true
            }

        } else {
            //if the touchpad is off or if the touchpad is currently touched, we return true
            return true
        }
    }
    
    /**
    Reset the alert variables to zero
    */
    func resetAlert(){
        self.alert_1 = false
        self.alert_2 = false
        self.alert_3 = false
    }
    
    /**
    Display an alert sound depending on the progress and which alert has already been played
     Update the alert variables accordingly
    */
    func displayAlert(progress: Double){
        //alert 1
        if !self.alert_1 && (1 - progress) < self.alertTimeAllocation {
            print("alert 1")
            self.runAction(alertSFX)
            self.alert_1 = true
        }
        //alert 2
        else if !self.alert_2 && (1 - progress) < self.alertTimeAllocation * (2/3) {
            print("alert 2")
            self.runAction(alertSFX)
            self.alert_2 = true
        }
        //alert 3
        else if !self.alert_3 && (1 - progress) < self.alertTimeAllocation * (1/3) {
            print("alert 3")
            self.runAction(alertSFX)
            self.alert_3 = true
        }
    }


}
