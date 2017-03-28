//
//  ImageHelper.swift
//  What I See
//
//  Created by Ibrahim Al-Khatib on 3/28/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class ImageHelper: NSObject {

    class func rotateImageToRightRotation(img:UIImage) -> UIImage {
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = .identity
        // Rotate image clockwise by 90 degree
        if (img.imageOrientation == UIImageOrientation.up) {
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.down
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: img.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        }
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        }
        
        if (img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: img.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        }
        
        if (img.imageOrientation == UIImageOrientation.upMirrored
            || img.imageOrientation == UIImageOrientation.downMirrored) {
            
            transform = transform.translatedBy(x: img.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.rightMirrored) {
            
            transform = transform.translatedBy(x: img.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let context:CGContext = CGContext(data: nil, width: Int(img.size.width), height: Int(img.size.height),
                                          bitsPerComponent: img.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                          space: img.cgImage!.colorSpace!,
                                          bitmapInfo: img.cgImage!.bitmapInfo.rawValue)!;
        context.concatenate(transform)
        
        
        if (img.imageOrientation == UIImageOrientation.left
            || img.imageOrientation == UIImageOrientation.leftMirrored
            || img.imageOrientation == UIImageOrientation.right
            || img.imageOrientation == UIImageOrientation.rightMirrored
            || img.imageOrientation == UIImageOrientation.up
            ) {
            
            context.draw(img.cgImage!, in: CGRect(x: 0, y: 0, width: img.size.height, height: img.size.width))
        } else {
            context.draw(img.cgImage!, in: CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = context.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }

}
