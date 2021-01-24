//
//  RecipeDao.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import CoreData

class RecipeDao : Dao{
    
    //fields
    typealias T = Recipe
    
    typealias UpdateParams = (title: String, imagePath: String, descriptions :String, ingredients : [Ingredient])
    
    //storage access
    private let storage : DataStorage
    
    //init
    init(storage: DataStorage){
        self.storage = storage
    }
    
    //protocol functions
    func insert(element: Recipe) -> Bool {
        return storage.recipeManagementSystem.add(recipe: element)
    }
    
    func delete(id: NSManagedObjectID) -> Recipe? {
        return storage.recipeManagementSystem.remove(id: id);
    }
    
    func update(id: NSManagedObjectID, params: (title: String, imagePath: String, descriptions: String, ingredients: [Ingredient])) -> Bool {
        //update simple params
        guard let oldElement = storage.recipeManagementSystem.get(id: id) else{
            return false
        }
        
        let oldData = (title: oldElement.title ?? String.EMPTY, imagePath: oldElement.imagePath ?? String.EMPTY, descriptions: oldElement.descriptions ?? [String]().description)
        
        //try to update simple data
        let simpleSuccess = storage.recipeManagementSystem.updateSimpleData(id: id, data: (title: params.title, imagePath: params.imagePath, descriptions: params.descriptions))
        
        if !simpleSuccess{
            //rollback
            storage.recipeManagementSystem.updateSimpleData(id: id, data: oldData)
            return false
        }
        
        // Delete all ingredients of recipe and add new ones
        let deleteSuccess = storage.recipeManagementSystem.clearIngredientsOfRecipe(id: id)
        
        if !deleteSuccess{
            //rollback
            storage.recipeManagementSystem.updateSimpleData(id: id, data: oldData)
            return false
        }
        
        let addSuccess = storage.recipeManagementSystem.addIngredientsToRecipe(id: id, ingredients: params.ingredients)
        
        if !addSuccess{
            //rollback
            storage.recipeManagementSystem.updateSimpleData(id: id, data: oldData)
            return false
        }
        
        return true
    }
    
    func get(id: NSManagedObjectID) -> Recipe? {
        return storage.recipeManagementSystem.get(id: id)
    }
    
    func getAll() -> [Recipe] {
        return storage.recipeManagementSystem.getAll().sorted{(r1: Recipe, r2: Recipe) -> Bool in
            (r1.title ?? String.EMPTY) < (r2.title ?? String.EMPTY)
        }
        //print("Debug recipe sort: \(sorted.map{$0.title ?? String.EMPTY}.description)")
        
    }
    
    func clear() -> Bool {
        //TODO: implement clear
        return false
    }
    
    //further functions
    
    func getImagePath(id: NSManagedObjectID) -> String?{
        return storage.recipeManagementSystem.get(id: id)?.imagePath
    }
    
    //DEPRECATED
    /*func getIngredientById(id: NSManagedObjectID) -> Ingredient?{
        //TODO: Implement read of ingredient
        return nil
    }*/
    
    
    
    
}
