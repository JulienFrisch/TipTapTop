//
//  LevelConfigurations.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/2/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import Foundation
import UIKit


//MARK: Helper Classes and methods
/**
Error Types for our plist configuration
 */
enum ConfigurationError: ErrorType{
    case InvalidResource
    case ConversionError
    case InvalidKey
    case LevelError
    case GamePlayError
    case MusicsError
    case SFXError
    case ColorsError
}
/**
 Class used to retrieve the data from a plist
 */
class PListConverter{
    
    /**
    Convert a plist into a dictionary.
    Since we are not going to store data, we can use type methods that can be called directly on the class rather than on an instance
     */
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> NSDictionary{
        //we retrieve the path of the plist
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw ConfigurationError.InvalidResource
        }
        
        //we load the plist into a dictionary
        guard let dictionary = NSDictionary(contentsOfFile: path) else {
            throw ConfigurationError.ConversionError
        }
        
        return dictionary
    }
}

struct GamePlay {
    let maxTouchPadsActivated: Int
    let initialSwitchTime: NSTimeInterval
    let finalSwitchTime: NSTimeInterval
    let maxGameTime: NSTimeInterval
    let warningTimeAllocation: Double
    
    init(maxTouchPadsActivated: Int, initialSwitchTime: NSTimeInterval, finalSwitchTime: NSTimeInterval, maxGameTime: NSTimeInterval, warningTimeAllocation: Double ){
        self.maxTouchPadsActivated = maxTouchPadsActivated
        self.initialSwitchTime = initialSwitchTime
        self.finalSwitchTime = finalSwitchTime
        self.maxGameTime  = maxGameTime
        self.warningTimeAllocation = warningTimeAllocation
    }
}

struct Colors {
    let backGroundColor: UIColor
    
    init(backGroundColor: UIColor){
        self.backGroundColor = backGroundColor
    }
}

struct Musics {
    let win: String
    let gameOver: String
    
    init(win: String, gameOver: String){
        self.win = win
        self.gameOver = gameOver
    }
}

struct Sounds {
    let switchSFX: String
    let alertSFX : String
    let touchSFX: String
    
    init(switchSFX: String, alertSFX: String, touchSFX: String){
        self.switchSFX = switchSFX
        self.alertSFX = alertSFX
        self.touchSFX = touchSFX
    }
}

//TO-DO: Add throwables instead of prints
//TO-DO: Create some sub-struct
struct LevelConfigurations{
    //GamePlay
    var gameplay: GamePlay?
    
    //Colors
    var colors: Colors?
    
    //Musics
    var musics: Musics?
    
    //sound effects
    var sounds: Sounds?
    
    init(levelName: String) throws {
        //we retrieve the level configurations file
        let configDict = try PListConverter.dictionaryFromFile("LevelConfigurations", ofType: "plist")
            
        //we load the dictionnary for the required level
        if let currentLevelConfig: NSDictionary = configDict.valueForKey(levelName) as? NSDictionary{
            
            //we load the gamePlay
            if let gamePlay: NSDictionary = currentLevelConfig.valueForKey("GamePlay") as? NSDictionary,
                let maxTouch = gamePlay.valueForKey("maxTouchPadsActivated") as? Int,
                let initialSwitchTime = gamePlay.valueForKey("initialSwitchTime") as? NSTimeInterval,
                let finalSwitchTime = gamePlay.valueForKey("finalSwitchTime") as? NSTimeInterval,
                let maxGameTime = gamePlay.valueForKey("maxGameTime") as? NSTimeInterval,
                let warningTimeAllocation = gamePlay.valueForKey("warningTimeAllocation") as? Double
            {
                self.gameplay = GamePlay(maxTouchPadsActivated: maxTouch, initialSwitchTime: initialSwitchTime, finalSwitchTime: finalSwitchTime, maxGameTime: maxGameTime, warningTimeAllocation: warningTimeAllocation)
            } else {
                print("Incomplete GamePlay settings for:\(levelName)")
                throw(ConfigurationError.GamePlayError)
            }
                
            //we load the colors
            if let colors: NSDictionary = currentLevelConfig.valueForKey("Colors") as? NSDictionary,
                let background = colors.valueForKey("BackGround") as? NSDictionary,
                let backgroundRed = background.valueForKey("Red") as? CGFloat,
                let backgroundBlue = background.valueForKey("Blue") as? CGFloat,
                let backgroundGreen = background.valueForKey("Green") as? CGFloat,
                let backgroundAlpha = background.valueForKey("Alpha") as? CGFloat
            {
                self.colors = Colors(backGroundColor: UIColor(red: backgroundRed / 255, green: backgroundBlue / 255, blue: backgroundGreen / 255, alpha: backgroundAlpha))
            } else {
                print("Incomplete Colors settings for:\(levelName)")
                throw(ConfigurationError.ColorsError)
            }
                
            //we load the musics
            if let musics: NSDictionary = currentLevelConfig.valueForKey("Musics") as? NSDictionary,
                let win = musics.valueForKey("Win") as? String,
                let gameOver = musics.valueForKey("GameOver") as? String
            {
                self.musics = Musics(win: win, gameOver: gameOver)
            } else {
                print("Incomplete music definition for:\(levelName)")
                throw(ConfigurationError.MusicsError)
            }
                
            //we load the sounds
            if let sounds: NSDictionary = currentLevelConfig.valueForKey("Sounds") as? NSDictionary,
                let alertSFX = sounds.valueForKey("Alert") as? String,
                let switchSFX = sounds.valueForKey("Switch") as? String,
                let touchSFX = sounds.valueForKey("Touch") as? String
            {
                self.sounds = Sounds(switchSFX: switchSFX, alertSFX: alertSFX, touchSFX: touchSFX)
            } else {
                print("Incomplete sounds definition for:\(levelName)")
                throw(ConfigurationError.SFXError)
            }
                
        } else {
            print("Not able to load the settings for: \(levelName)")
            throw(ConfigurationError.LevelError)
        }
    }
}