//
//  HUDNode.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 6/25/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class ProgressNode: SKNode {
    
    var progress = 0
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
        progressNode.name = "ProgressNode"
        
        
        //we add the grey bar that shows the total expected duration
        let rect = CGRect(x: progressNode.verticalInterspace , y: 0, width: inFrame.width - 2 * progressNode.verticalInterspace , height: progressNode.height)
        let greyBar = SKShapeNode(rect: rect, cornerRadius: 1.0)
        greyBar.fillColor = UIColor.grayColor()
        
        progressNode.addChild(greyBar)
        
        return progressNode
    }
}
