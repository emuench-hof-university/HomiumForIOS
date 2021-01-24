//
//  RecipeEditDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class RecipeEditDataHandler : DataHandler{
    
    //fields
    private let dao = DataStorage.recipeDao
    private let id : NSManagedObjectID?
    private var loadedImage: UIImage? = nil
    private let pictureHandler = PictureHandler()
    
    var isEditMode : Bool {
        get{
            return id != nil
        }
    }
    
    //helper
    private let decoder : JSONDecoder = JSONDecoder()
    
    
    //init
    init(recipeId : NSManagedObjectID?){
        self.id = recipeId
    }
    
    //type
    typealias T = (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String])
    
    //protocol functions
    func getData() -> (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String])? {
        
        if let uid = id {
            guard let recipe = dao.get(id: uid) else{
                return nil
            }
            
            let recipeIngredients : [Ingredient] = (recipe.consistsof?.allObjects as? [Ingredient] ?? []).sorted{$0.objectID.description < $1.objectID.description}
            
            var recipeDescriptions : [String] = []
            if let recipeDescriptionData = recipe.descriptions?.data(using: .utf8){
                let decoded = try? decoder.decode([String].self, from: recipeDescriptionData)
                recipeDescriptions = decoded ?? []
            }
            
            loadedImage = pictureHandler.loadPicture(imgPath: recipe.imagePath ?? String.EMPTY) ?? UIImage.noRecipeImage ?? UIImage()
            print("ImagePath: \(recipe.imagePath ?? "Anscheined gibts hier keinen Imagepath")")
            
            return (title: recipe.title ?? String.EMPTY, image: loadedImage ?? UIImage(), ingredients: recipeIngredients.map{(title: $0.title ?? String.EMPTY, quantity: $0.quantity.description.toIntegerStyle(), unit: $0.unit ?? String.EMPTY)},descriptions : recipeDescriptions)
        }
        else{
            return nil
        }
    }
    
    func putData(data: (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String])) -> Bool {
        //get context
        guard let context = getContext() else{
            return false
        }
        
        //differenciate between update and add
        if let uid = id {
            //update
            return update(uid: uid, data: data, context: context)
            
            
        }
        else{
            //add
            return add(data: data, context: context)
        }
        
    }
    
    func delete() -> Bool {
        guard let uid = id else{
            return false
        }
        pictureHandler.deletePicture(path: dao.getImagePath(id: uid) ?? String.EMPTY)
        return dao.delete(id: uid) != nil
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    //help functions
    private func update(uid: NSManagedObjectID, data: (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String]), context: NSManagedObjectContext) -> Bool{
        //update
        //ingredients
        var ingrdts = [Ingredient]()
        
        for element in data.ingredients{
            let ingr = Ingredient(entity: Ingredient.entity(), insertInto: context)
            ingr.title = element.title
            ingr.unit = element.unit
            guard let quantity = Double(element.quantity) else{
                return false
            }
            ingr.quantity = quantity
            ingrdts.append(ingr)
        }
        
        //descriptions
        let descriptionString = data.descriptions.filter{$0.isNotBlankOrEmpty()}.description
        
        //handle image
        if let currentImage = loadedImage {
            //current image existing
            var currentImagePath = dao.getImagePath(id: uid) ?? String.EMPTY
            if !(currentImage.isEqual(data.image)){
                //delete current image
                let sucess = pictureHandler.deletePicture(path: currentImagePath)
                
                //save new picture
                if let noRecipePicture = UIImage.noRecipeImage{
                    if (data.image.isEqual(noRecipePicture)){
                        currentImagePath = String.EMPTY
                    }
                    else if (sucess || currentImage.isEqual(noRecipePicture)){
                        currentImagePath = pictureHandler.savePicture(image: data.image) ?? String.EMPTY
                    }
                }
                else if sucess{
                    currentImagePath = pictureHandler.savePicture(image: data.image) ?? String.EMPTY
                }
            }
            
            
            return dao.update(id: uid, params: (title: data.title, imagePath: currentImagePath, descriptions: descriptionString, ingredients: ingrdts))
        }
        else{
            //current image not existing
            let currentImagePath = pictureHandler.savePicture(image: data.image) ?? String.EMPTY
            return dao.update(id: uid, params: (title: data.title, imagePath: currentImagePath, descriptions: descriptionString, ingredients: ingrdts))
        }
    }
    
    private func add(data: (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String]), context: NSManagedObjectContext) -> Bool{
        
        let recipe = Recipe(entity: Recipe.entity(), insertInto: context)
        
        //assign "normal" values
        recipe.title = data.title
        recipe.descriptions = data.descriptions.filter{$0.isNotBlankOrEmpty()}.description
        
        //assigning image
        var imagePath = String.EMPTY
        if let noRcpImg = UIImage.noRecipeImage {
            if data.image.isEqual(noRcpImg){
                imagePath = String.EMPTY
            }
            else{
                imagePath = pictureHandler.savePicture(image: data.image) ?? String.EMPTY
            }
        }
        else{
            imagePath = pictureHandler.savePicture(image: data.image) ?? String.EMPTY
        }
        recipe.imagePath = imagePath
        
        //assign ingredients
        for element in data.ingredients{
            let ingr = Ingredient(entity: Ingredient.entity(), insertInto: context)
            ingr.title = element.title
            ingr.unit = element.unit
            guard let quantity = Double(element.quantity) else{
                return false
            }
            ingr.quantity = quantity
            recipe.addToConsistsof(ingr)
        }
        
        return dao.insert(element: recipe)
    }
    
}
