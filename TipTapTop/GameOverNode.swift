//
//  GameOverNode.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 6/24/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import SpriteKit

class GameOverNode: SKNode {
    
    /**
    Create a game over SKNode at the required postion
    */
    class func gameOverAtPosition(position: CGPoint) -> GameOverNode{
        //we create the GameOverNode instance and place it
        let gameOver = GameOverNode()
        gameOver.position = position
        
        //we add a label
        let gameOverLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        gameOverLabel.name = "GameOverLabel"
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 48
        gameOverLabel.position = CGPointMake(0, 0)
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverLabel.zPosition = 11
        gameOver.addChild(gameOverLabel)
        
        return gameOver
    }
    
    func performAnimation(){
        let gameOverLabel = self.childNodeWithName("GameOverLabel") as! SKLabelNode
        
        //we are going to increase the size of the label
        gameOverLabel.xScale = 0
        gameOverLabel.yScale = 0
        let scaleUp = SKAction.scaleTo(1.2, duration: 0.75)
        let scaleDown = SKAction.scaleTo(0.9, duration: 0.25)
        
        //and we are going to create a new play again label
        let run = SKAction.runBlock({
            let touchRestart = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            touchRestart.text = "Touch Here To Restart"
            touchRestart.fontSize = 24
            touchRestart.position = CGPointMake(gameOverLabel.position.x, gameOverLabel.position.y - 40)
            touchRestart.zPosition = 11
            self.addChild(touchRestart)
        })
        
        let scaleSequence = SKAction.sequence([scaleUp,scaleDown,run])
        gameOverLabel.runAction(scaleSequence)
    }
}