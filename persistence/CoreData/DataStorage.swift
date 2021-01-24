//
//  DataStorage.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class DataStorage { //: PersistenceHandler
    //instance
    private static let instance = DataStorage()
    
    //daos for outer access
    static let shoppingDao : ShoppingDao = ShoppingDao(storage: DataStorage.instance)
    static let inventoryDao : InventoryDao = InventoryDao(storage: DataStorage.instance)
    static let recipeDao : RecipeDao = RecipeDao(storage: DataStorage.instance)
    
    //data structures for saving data
    let shoppingList = ShoppingList()
    let inventory = Inventory()
    let recipeManagementSystem = RecipeManagementSystem()
    
    
    //init
    private init(){
        shoppingList.loadData()
        inventory.loadData()
        recipeManagementSystem.loadData()
    }
    
    /*func syncWithPersistenceLayer(context: NSManagedObjectContext) -> Bool {
        return shoppingList.syncWithPersistenceLayer(context: context)
    }
    
    func loadData() -> Bool {
        return shoppingList.
    }*/
}
