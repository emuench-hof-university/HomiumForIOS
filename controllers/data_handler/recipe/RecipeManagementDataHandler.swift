//
//  RecipeManagementDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class RecipeManagementDataHandler : DataHandler{
    //type
    typealias T = [(id: NSManagedObjectID, title: String, image: UIImage)]
    
    //fields
    private let dao = DataStorage.recipeDao
    private let pictureHandler = PictureHandler()
    
    var onImageLoadedAsync : (Int,UIImage) -> Void = {_,_ in}
    
    //protocol functions
    func getData() -> [(id: NSManagedObjectID, title: String, image: UIImage)]? {
        let sortedObjData = dao.getAll()
            .sorted(by: {(r1: Recipe, r2: Recipe) -> Bool in
            return (r1.title?.lowercased() ?? String.EMPTY) < (r2.title?.lowercased() ?? String.EMPTY)
            })
        loadPicturesAsync(paths: sortedObjData.map{$0.imagePath ?? String.EMPTY})
        return sortedObjData.map{(id: $0.objectID,title: $0.title ?? String.EMPTY, image: UIImage.noRecipeImage ?? UIImage())}
    }
    
    func putData(data: [(id: NSManagedObjectID, title: String, image: UIImage)]) -> Bool {
        //put not allowed here
        return false
    }
    
    func delete() -> Bool {
        return dao.clear()
    }
    
    func delete(id: NSManagedObjectID) -> Bool{
        //delete image
        let imagePath = dao.getImagePath(id: id) ?? String.EMPTY
        pictureHandler.deletePicture(path: imagePath)
        //delete recipe
        return dao.delete(id: id) != nil
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    //private func
    private func loadPicturesAsync(paths: [String]){
        for (index, path) in paths.enumerated(){
            DispatchQueue.main.async {
                let image = self.pictureHandler.loadPicture(imgPath: path) ?? UIImage.noRecipeImage ?? UIImage()
                self.onImageLoadedAsync(index,image);
            }
        }
        
        
    }
}
