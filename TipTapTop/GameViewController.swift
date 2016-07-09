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
    
    var level = String()
        
    override func loadView() {
        super.loadView()
        //we make sure the view is some type SKView for the later function viewDidAppear
        self.view = SKView()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //we select a scene based on the level name updated previously within the LevelsViewController
        let scene: BaseGameScene?
        switch level {
            case "Vanilla_Easy": scene = Vanilla_Easy(fileNamed: "GameScene")
            case "Vanilla_Hard": scene = Vanilla_Hard(fileNamed: "GameScene")
            case "MultiTouch_Easy": scene = MultiTouch_Easy(fileNamed: "GameScene")
            case "MultiTouch_Hard": scene = MultiTouch_Hard(fileNamed: "GameScene")
            case "BigsAndSmalls_Easy": scene = BigsAndSmalls_Easy(fileNamed: "GameScene")
            case "BigsAndSmalls_Hard": scene = BigsAndSmalls_Hard(fileNamed: "GameScene")
            case "Motion_Easy": scene = Motion_Easy(fileNamed: "GameScene")
            case "Motion_Hard": scene = Motion_Hard(fileNamed: "GameScene")
            default: scene = BaseGameScene(fileNamed: "GameScene")
        }
        
        if let scene = scene {
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


    /**
     retrieve the Navigation View Controller
    */
    func retrieveNavigationController() -> UINavigationController {
        //we can force unwrap it because we know a navigation view controller exists
        return self.navigationController!
    }
    
}

/**
 Delegate methods so the SKScene can use the view
 */
protocol ViewControllerDelegate
{
    /**
    Send an error window
    */
    func showAlert(itle: String, message: String?, style: UIAlertControllerStyle );
    
    /**
    retrieve the Navigation Controller
    */
    func retrieveNavigationController() -> UINavigationController;
}
