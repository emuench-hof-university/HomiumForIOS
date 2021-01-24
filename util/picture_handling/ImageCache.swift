//
//  ImageCache.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 10.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ImageCache{
    //instance
    static let instance = ImageCache()
    
    //fields
    private var cacheData: [String: UIImage] = [:]
    
    //init
    private init(){
        
    }
    
    //functions
    func get(path: String) -> UIImage?{
        return cacheData[path]
    }
    
    func put(path: String,image: UIImage) -> Bool{
        cacheData[path] = image
        return true
    }
    
    func delete(path: String) -> Bool {
        let remVal = cacheData.removeValue(forKey: path)
        return remVal != nil
    }
    
    func remove(at path: String){
        cacheData.removeValue(forKey: path)
    }
}
