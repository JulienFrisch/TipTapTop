//
//  GameViewController.swift
//  TipTapTop
//
//  Created by Julien Frisch on 6/23/16.
//  Copyright (c) 2016 Julien Frisch. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, ViewControllerDelegate {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            /* Limit the size of the scene accordingly */
            scene.size = skView.bounds.size
            
            /* we make sure we pass the current view controller*/
            scene.viewController = self

            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //TO-DO: Create a return to menu button
    /**
     Show a configuration issue and return to main menu
     */
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = UIAlertControllerStyle.Alert){
        
        //we create the alert window
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        //we create the OK action
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

/**
 Delegate method to send eror messages
 */
protocol ViewControllerDelegate
{
    /**
    Send an error window
    */
    func showAlert(itle: String, message: String?, style: UIAlertControllerStyle );
}
