//
//  PictureLoader.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 10.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class PictureHandler{
    
    //fields
    private let fileHandler = ImageFileHandler()
    
    //functions
    func loadPicture(imgPath: String) -> UIImage?{
        if imgPath.isEmpty{
            return UIImage.noRecipeImage
        }
        else{
            //look for image in cache
            if let imageInCache = ImageCache.instance.get(path: imgPath){
                return imageInCache
            }
            
            let picture = fileHandler.loadPictureFromFilePath(path: imgPath)
            return picture
        }
    }
    
    
    
    func savePicture(image: UIImage) -> String?{
        let path = fileHandler.savePictureToFileSystem(image: image)
        print("imagepath is: \(path ?? "NO PATH")")
        if let validPath = path{
            ImageCache.instance.put(path: validPath, image: image)
        }
        
        return path
    }
    
    func deletePicture(path: String) -> Bool{
        if path.isEmpty{
            return false
        }
        
        let sucess = fileHandler.deletePictureAtPath(path: path)
        
        if sucess{
            ImageCache.instance.remove(at: path)
        }
        
        return sucess
    }
    
    
}


