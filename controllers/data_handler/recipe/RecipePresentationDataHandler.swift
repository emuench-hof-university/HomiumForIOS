//
//  RecipePresentationDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 04.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData
import UIKit

class RecipePresentationDataHandler : DataHandler{
    //fields
    private let dao = DataStorage.recipeDao
    private let decoder = JSONDecoder()
    private let pictureHandler = PictureHandler()
    let id : NSManagedObjectID!
    
    //init
    init(id: NSManagedObjectID){
        self.id = id
    }
    
    //type
    typealias T = (title: String, image: UIImage, ingredients: [(title: String, quantityDetails: String)], descriptions: [String])
    
    //protocol functions
    func delete() -> Bool {
        pictureHandler.deletePicture(path: dao.getImagePath(id: id) ?? String.EMPTY)
        return dao.delete(id: id) != nil
    }
    
    func getContext() -> NSManagedObjectContext? {
        //not avalible because of no put allowed
        return nil
    }
    
    func getData() -> (title: String, image: UIImage, ingredients: [(title: String, quantityDetails: String)], descriptions: [String])? {
        //check for data avalible
        guard let fetched = dao.get(id: id) else{
            return nil
        }
        
        //descriptions
        var descr : [String] = []
        if let recipeDescriptionData = fetched.descriptions?.data(using: .utf8){
            let decoded = try? decoder.decode([String].self, from: recipeDescriptionData)
            descr = decoded ?? []
        }
        
        //ingredients
        let ingredients = fetched.consistsof?.allObjects as? [Ingredient] ?? []
        let ingrFormat = ingredients.map{(title: $0.title ?? String.EMPTY ,quantityDetails:"\($0.quantity.description.toIntegerStyle()) \($0.unit ?? String.EMPTY)")}
        
        //image
        let image = pictureHandler.loadPicture(imgPath: fetched.imagePath ?? String.EMPTY) ?? UIImage.noRecipeImage ?? UIImage()
        
        //result
        return (title: fetched.title ?? String.EMPTY, image: image, ingredients : ingrFormat, descriptions: descr)
    }
    
    func putData(data: (title: String, image: UIImage, ingredients: [(title: String, quantityDetails: String)], descriptions: [String])) -> Bool {
        //no put allowed
        return false
    }
    
}
