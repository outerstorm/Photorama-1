//
//  ImageStore.swift
//  Photorama
//
//  Created by Andy Steinmann on 4/4/17.
//  Copyright © 2017 DLS. All rights reserved.
//
import UIKit

// to store images in a cache
class ImageStore: NSObject {
    let cache = NSCache<AnyObject, AnyObject>()
    
    func imageURLForKey(key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
        let imageURL = imageURLForKey(key: key)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: imageURL, options: [.atomic])
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        let imageURL = imageURLForKey(key: key)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch let deleteError {
            print("Error removing the image from disk: \(deleteError)")
        }
    }
}
