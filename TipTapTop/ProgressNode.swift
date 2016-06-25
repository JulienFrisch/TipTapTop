//
//  HUDNode.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 6/25/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

//TO-DO: create a struct to store nodes names
class ProgressNode: SKNode {
    
    //progress and size variables
    var progress: CGFloat = 0
    var computedWidth: CGFloat = 0 //computed later from parent frame
    
    //configuration
    let height: CGFloat = 5.0
    let verticalInterspace: CGFloat = 20.0
    
    /**
    Return a progress node that will have the width of the frame
    */
    class func progressAtPosition(position: CGPoint, inFrame: CGRect)-> ProgressNode{
        let progressNode = ProgressNode()
        progressNode.position = position
        
        
        //we make sure the node is in front of everything else
        progressNode.zPosition = 10
        
        //we name our SKNode to find it more easily later
        progressNode.name = "ProgressNode"
        
        //we store the width computed from the parent frame
        progressNode.computedWidth = inFrame.width - 2 * progressNode.verticalInterspace

        
        //we add the grey bar that shows the total expected duration
        let rectGrey = CGRect(x: progressNode.verticalInterspace , y: 0, width: progressNode.computedWidth , height: progressNode.height)
        let greyBar = SKShapeNode(rect: rectGrey, cornerRadius: progressNode.height / 2)
        greyBar.fillColor = UIColor.grayColor()
        progressNode.addChild(greyBar)
        
        return progressNode
    }
    
    /**
    We replace the greenbar by another one to reflect the game progress
    */
    func updateProgress(progress: CGFloat){
        //if it exists, we remove the previous greenBar
        if let oldBar = self.childNodeWithName("GreenBar") {
            oldBar.removeFromParent()
        }
        
        //we add a new greenBar
        self.addChild(createGreenBar(progress))
    }
    
    /**
    Create a green bar based on the progress
    */
    func createGreenBar(progress: CGFloat) -> SKShapeNode {
        //we add a green bar that shows the current duration, with a null width for now
        let rectGreen = CGRect(x: self.verticalInterspace , y: 0, width: min(progress,1) * self.computedWidth , height: self.height)
        let greenBar = SKShapeNode(rect: rectGreen, cornerRadius: self.height / 2)
        greenBar.fillColor = UIColor.greenColor()
        
        //we name the green bar so it can be removed later
        greenBar.name = "GreenBar"
        //we place the greenbar in front of the grey bar
        //TO-DO: remove ZPOsition
        greenBar.zPosition = 11
        
        return greenBar
    }
}
