//
//  RecipeManagementSystem.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData
import UIKit

class RecipeManagementSystem : PersistenceHandler{
    //fields
    private var recipes : [NSManagedObjectID:Recipe] = [:]
    
    //functions
    func add(recipe: Recipe) -> Bool{
        //get context
        guard let context = recipe.managedObjectContext else {
            return false
        }
        
        let success = syncWithPersistenceLayer(context: context)
    
        if(success){
            recipes[recipe.objectID] = recipe
            //recipes.append(recipe)
        }
        
        return success
    }
    
    func remove(id: NSManagedObjectID) -> Recipe?{
        //get all needed data
        /*guard let index = getIndexForId(id: id) else{
            return nil
        }*/
        
        guard let element = recipes[id] else{
            return nil
        }
        
        guard let context = getContext() else{
            return nil
        }
        
        context.delete(element)
        let sucess = syncWithPersistenceLayer(context: context)
        
        if sucess{
            return recipes.removeValue(forKey: id)
        }
        else{
            return nil
        }
        
    }
    
    func get(id: NSManagedObjectID) -> Recipe?{
        /*guard let index = getIndexForId(id: id) else{
            return nil
        }*/
        
        return recipes[id]
    }
    
    func getAll() -> [Recipe]{
        loadData()
        return Array(recipes.values)
    }
    
    func updateSimpleData(id: NSManagedObjectID, data: (title: String, imagePath: String, descriptions: String)) -> Bool{
        //get values
        guard let context = getContext() else{
            return false
        }
        
        /*guard let index = getIndexForId(id: id) else{
            return false
        }*/
        
        //old values
        guard let element = recipes[id] else{
            return false
        }
        let oldTitle = element.title
        let oldImgPath = element.imagePath
        let oldDescriptions = element.descriptions
        
        //try to update
        recipes[id]?.title = data.title
        recipes[id]?.descriptions = data.descriptions
        recipes[id]?.imagePath = data.imagePath
        
        //try to persist
        let success = syncWithPersistenceLayer(context: context)
        
        //rollback if no success
        if !success{
            recipes[id]?.title = oldTitle
            recipes[id]?.descriptions = oldDescriptions
            recipes[id]?.imagePath = oldImgPath
        }
        
        return success
    }
    
    func clearIngredientsOfRecipe(id: NSManagedObjectID) -> Bool{
        //get values
        guard let context = getContext() else{
            return false
        }
        
        /*guard let index = getIndexForId(id: id) else{
            return false
        }*/
        //old values
        guard let element = recipes[id] else{
            return false
        }
        let oldIngredients : [Ingredient] = element.consistsof?.allObjects as? [Ingredient] ?? []
        
        //try to remove and persist
        recipes[id]?.removeFromConsistsof(NSSet(array: oldIngredients))
        oldIngredients.forEach{
            context.delete($0)
        }
        
        let persistSuccess = syncWithPersistenceLayer(context: context)
        
        //rollback if no success
        let ingredientSize = recipes[id]?.consistsof?.count ?? 0
        if (!persistSuccess){
            recipes[id]?.addToConsistsof(NSSet(array: oldIngredients))
            
        }
        else if (ingredientSize != 0){
            //this case will probably never happen
            return false
        }
        
        return persistSuccess
    }
    
    func addIngredientsToRecipe(id: NSManagedObjectID, ingredients: [Ingredient]) -> Bool{
        //get values
        guard let context = getContext() else{
            return false
        }
        
        /*guard let index = getIndexForId(id: id) else{
            return false
        }*/
        
        let ingrSet = NSSet(array: ingredients)
        
        //try to change things
        guard let _ = recipes[id] else{
            return false
        }
        recipes[id]?.addToConsistsof(ingrSet)
        
        let sucess = syncWithPersistenceLayer(context: context)
        
        //rollback if no success
        if !sucess{
            recipes[id]?.removeFromConsistsof(ingrSet)
        }
        
        return sucess
    }
    
    //protocol functions
    func syncWithPersistenceLayer(context: NSManagedObjectContext) -> Bool {
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    func loadData() -> Bool {
       //get Context
        guard let context = getContext() else{
            return false
        }
        
        do{
            let recipeArr = try context.fetch(Recipe.fetchRequest()) as [Recipe]
            recipeArr.forEach{
                recipes[$0.objectID] = $0
            }
            return true
        }
        catch{
            print("ERROR while loading recipe data")
            return false
        }
    }
    
    //help functions
    private func getContext() -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    /*private func getIndexForId(id: NSManagedObjectID) -> Int? {
        for (index,element) in recipes.enumerated(){
            if(element.objectID == id){
                return index
            }
        }
        return nil
    }*/
    
    
}
