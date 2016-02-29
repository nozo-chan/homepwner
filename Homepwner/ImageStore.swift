//
//  ImageStore.swift
//  Homepwner
//
//  Created by nozomi morel on 25/02/16.
//  Copyright © 2016 Jero. All rights reserved.
//

import UIKit

class ImageStore {
   

    let cache = NSCache ()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
        //create full url for image 
        let imageURL = imageURLForKey(key)
        //turn image into png
        if let data = UIImagePNGRepresentation(image) {
            //write it to full url 
            data.writeToURL(imageURL, atomically: true)
        }
    }
    
    func imageForKey(key:String) -> UIImage? {
        if let exisitingImage = cache.objectForKey(key) as? UIImage {
            return exisitingImage
        }
        
        let imageURL = imageURLForKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        let imageURL = imageURLForKey(key)
        do {
            try  NSFileManager.defaultManager().removeItemAtURL(imageURL)
        }
        catch let deleteError {
            print("error removing the image from disk: \(deleteError)")
        }
    }
       
    func imageURLForKey(key: String) -> NSURL {
        let documentsDirectories =
            NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.URLByAppendingPathComponent(key)
    }
}

