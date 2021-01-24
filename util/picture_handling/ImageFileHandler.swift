//
//  ImageFileHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 10.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit


class ImageFileHandler {
    //static fields
    private static let folderName = "HomiumImages"
    
    private let imagePath : String!
    
    //init
    init(){
        //try to get image directory and create it if it does not exist
        let directory = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true)[0]
        guard var dirUrl = URL(string: directory) else{
            imagePath = String.EMPTY
            return
        }
        dirUrl.appendPathComponent(ImageFileHandler.folderName)
        imagePath = dirUrl.absoluteString
        
        let alreadyExists = FileManager.default.fileExists(atPath: imagePath)
        
        if !alreadyExists{
            do{
                try FileManager.default.createDirectory(atPath: imagePath, withIntermediateDirectories: true, attributes: nil)
                print("SUCCESS: CREATED IMAGE DIRECTORY")
            }
            catch{
                print(error.localizedDescription)
                print("ERROR:CANT CREATE IMAGE DIRECTORY")
            }
        }
        
    }
    
    //private functions
    func loadPictureFromFilePath(path: String) -> UIImage?{
        guard let data = FileManager.default.contents(atPath: path) else{
            return nil
        }
            
        return UIImage(data: data)
    }
    
    func savePictureToFileSystem(image: UIImage) -> String?{
        
        let directory = NSSearchPathForDirectoriesInDomains(.picturesDirectory, .userDomainMask, true)[0]
        guard let dirUrl = URL(string: directory) else{
            return nil
        }
        
        if imagePath.isEmpty{
            return nil
        }
        
        let fileName = "HOMIUMFORIOS_PICTURE_\(UUID().description)_\(Date().description)"
        let filePath = dirUrl.appendingPathComponent(ImageFileHandler.folderName, isDirectory: true).appendingPathComponent(fileName).appendingPathExtension(".jpg").absoluteString
        let jpgData = image.jpegData(compressionQuality: 0.75)
        
        let sucess = FileManager.default.createFile(atPath: filePath, contents: jpgData, attributes: nil)
        
        if sucess {
            return filePath
        }
        else{
            return nil
        }
    }
    
    func deletePictureAtPath(path: String) -> Bool{
        do{
            try FileManager.default.removeItem(atPath: path)
            return true
        }
        catch{
            return false
        }
    }
}
