//
//  PListManager.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/19/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import Foundation

/**
 Class used to retrieve or write some data from or to a plist
 */
class PListManager{
    
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
    
    /**
    write a value in a plist file
    */
    class func writeInFile(resource: String, ofType type: String, key: String, value: NSObject) throws{
        //we retrieve the path of the plist
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw ConfigurationError.InvalidResource
        }

        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject("yuhou", forKey: "test")
        //...
        
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        print("and done")
    }
    
    class func loadLevelData() throws  -> NSDictionary{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0)as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("LevelProgress.plist")
            
        let fileManager = NSFileManager.defaultManager()
            
        // Check if file exists
        if(!fileManager.fileExistsAtPath(path))
        {
            // If it doesn't, copy it from the default file in the Resources folder
            if let bundle = NSBundle.mainBundle().pathForResource("LevelProgress", ofType: "plist"){
                try fileManager.copyItemAtPath(bundle, toPath: path)
            } else {
                print("Cannot find default levelProgress.plist")
            }
        }
        return NSDictionary(contentsOfFile: path)!
    }
    
    class func saveLevelData(data: NSDictionary){
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("LevelProgress.plist")
        
        data.writeToFile(path, atomically: true)
    }
}