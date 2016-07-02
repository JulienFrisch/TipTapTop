//
//  LevelConfigurations.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/2/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import Foundation

//MARK: Helper Classes and methods

/**
Error Types for our plist configuration
 */
enum ConfigurationError: ErrorType{
    case InvalidResource
    case ConversionError
    case InvalidKey
}
/**
 Class used to retrieve the data from a plist
 */
class PListConverter{
    
    /**
    Convert a plist into a dictionary.
    Since we are not going to store data, we can use type methods that can be called directly on the class rather than on an instance
     */
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String: AnyObject]{
        //we retrieve the path of the plist
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw ConfigurationError.InvalidResource
        }
        
        //we load the plist into a dictionary
        guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else {
            throw ConfigurationError.ConversionError
        }
        
        return castDictionary
    }
}