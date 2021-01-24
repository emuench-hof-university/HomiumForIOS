//
//  ShoppingDao.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 18.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingDao : Dao{
    
    //types
    typealias T = ShoppingItem
    typealias UpdateParams = (title : String,quantity: Double, unit:String, selectedState: Bool )
    
    //storage access
    private let storage : DataStorage
    
    //init
    init(storage: DataStorage){
        self.storage = storage
    }
    
    //protocol functions
    func insert(element : ShoppingItem) -> Bool{
        //storage interaction
        return storage.shoppingList.add(element: element)
    }
    func delete(id : NSManagedObjectID) -> ShoppingItem?{
        return storage.shoppingList.delete(id: id)
    }
    func update(id : NSManagedObjectID, params: (title : String,quantity: Double, unit:String, selectedState: Bool )) -> Bool{
        
        return storage.shoppingList.update(id: id, newTitle: params.title, newQuantity: params.quantity, newUnit: params.unit, newSelectedState: params.selectedState)
    }
    func get(id: NSManagedObjectID) -> ShoppingItem?{
        return storage.shoppingList.get(id: id)
    }
    func getAll() -> [ShoppingItem]{
        return storage.shoppingList.getAll()
    }
    
    func clear() -> Bool{
        //TODO : implement clear
        return false
        
    }
    
    func deleteAll(in items: [ShoppingItem]) -> Bool{
        for item in items{
            let sucess = delete(id: item.objectID) != nil
            
            if !sucess{
                return false
            }
        }
        
        return true
    }
    
    func changeSelectedState(id: NSManagedObjectID?) -> Bool{
        guard let uid = id else{
            return false
        }
        
        return storage.shoppingList.changeSelectedState(id: uid)
    }
    
    /*func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }*/
    
    
    
}
