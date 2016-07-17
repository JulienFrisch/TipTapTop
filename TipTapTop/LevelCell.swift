//
//  LevelCell.swift
//  TipTapTouch
//
//  Created by Julien Frisch on 7/13/16.
//  Copyright © 2016 Julien Frisch. All rights reserved.
//

import UIKit
import SpriteKit

/**
 Custom cell that loads a picture and a label
 */
class LevelCell: UITableViewCell {
    
    /**
    Set-Up the cell as per our customized specifications
    */
    func setUpCell(levelName: String){
        self.textLabel?.numberOfLines = 0
        self.textLabel?.text = levelName
        //cell.textLabel?.attributedText = self.makeAttributedString(title: self.levels[indexPath.row], subtitle: "")
        
        //we add an image
        self.imageView?.image = createDisk(30.0, imageName: "default")
        
    }
    
    //MARK: Helper Methods
    
    /**
    Create a disk of a certain radius based on an image sample
    */
    func createDisk(radius: CGFloat, imageName: String) -> UIImage?{
        let size = CGSize(width: radius * 2, height: radius * 2)
        if let image = UIImage(named: imageName){
            let resizedImage = resizeImage(size, image: image)
            let roundedImage = maskRoundedImage(resizedImage, radius: radius, strokeColor: UIColor.grayColor())
            let alphaImage = setAlpha(roundedImage, value: 0.2)
            return alphaImage
        } else {
            print("no image available for \(imageName)")
            return nil
        }
    }
    
    /**
    Convenient method to resize an image
     */
    func resizeImage(size: CGSize, image: UIImage) -> UIImage{
        //we resize the image
        let hasAlpha = false //false to handle potential transparency
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    /**
    Convenient method to crop an image into a disk
    */
    func maskRoundedImage(image: UIImage, radius: CGFloat, strokeColor: UIColor) -> UIImage {
        //we create our image layer
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        //we update the stroke
        layer.borderWidth = 0.5
        layer.borderColor = strokeColor.CGColor
        
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    /**
    Conveninent method to change the image alpha
    */
    func setAlpha(image: UIImage, value:CGFloat) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext();
        let area = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height);
        
        CGContextScaleCTM(ctx, 1, -1);
        CGContextTranslateCTM(ctx, 0, -area.size.height);
        CGContextSetBlendMode(ctx, CGBlendMode.Multiply);
        CGContextSetAlpha(ctx, value);
        CGContextDrawImage(ctx, area, image.CGImage);
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }

}


