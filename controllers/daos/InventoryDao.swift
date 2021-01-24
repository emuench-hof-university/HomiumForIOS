//
//  InventoryDao.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import CoreData

class InventoryDao : Dao{
    //types
    typealias T = InventoryItem
    
    typealias UpdateParams = (title : String,quantity: Double, unit:String, location: String )
    
    //storage access
    private let storage : DataStorage
    
    //init
    init(storage: DataStorage){
        self.storage = storage
    }
    
    //protocol functions
    func insert(element: InventoryItem) -> Bool {
        return storage.inventory.add(element: element)
    }
    
    func delete(id: NSManagedObjectID) -> InventoryItem? {
        return storage.inventory.delete(at: id)
    }
    
    func update(id: NSManagedObjectID, params: (title: String, quantity: Double, unit: String, location: String)) -> Bool {
        return storage.inventory.update(id: id, params: params)
    }
    
    func get(id: NSManagedObjectID) -> InventoryItem? {
        return storage.inventory.get(id)
    }
    
    func get(where predicate: (InventoryItem) -> Bool) -> [InventoryItem]{
        return storage.inventory.getAll().filter(predicate)
    }
    
    func getAll() -> [InventoryItem] {
        //get All Items
        let allInventoryItems = storage.inventory.getAll()
        
        // get prefered sort alogorithm
        let preferedSortAlgorithId = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_SORT_ALGORITHM_ID) ?? InventorySortAlgorithms.alphabeticSort.id
        guard let sortAlgorithm = InventorySortAlgorithms.getById(id: preferedSortAlgorithId) else{
            return allInventoryItems
        }
        
        //return sorted list
        return allInventoryItems.sorted(by: sortAlgorithm.algorithm)
    }
    
    func mergeAll(in items: [InventoryItem]) -> Bool{
        for item in items{
            var sucess = false
            if let existingItem = get(id: item.objectID){
                //update
                sucess = update(id: existingItem.objectID, params: (title: existingItem.title ?? String.EMPTY, quantity: item.quantity, unit: item.unit ?? String.EMPTY, location: existingItem.location ?? String.EMPTY))
            }
            else{
                //add
                sucess = insert(element: item)
            }
            
            if !sucess{
                return false
            }
            
        }
        
        return true
    }
    
    func clear() -> Bool {
        storage.inventory.clear()
        return (storage.inventory.count == 0)
    }
    
    //functions
    func getSimilarItem(id: NSManagedObjectID?,title: String, unit: String, location: String) -> InventoryItem?{
        for item in getAll(){
            //get values for title and unit
            guard let itemTitle = item.title?.lowercased() else {
                continue
            }
            
            guard let itemUnit = item.unit?.lowercased() else{
                continue
            }
            
            guard let itemLocation = item.location?.lowercased() else{
                continue
            }
            
            //compare values
            if (title.lowercased() == itemTitle) && (unit.lowercased() == itemUnit) && (location.lowercased() == itemLocation) && (id != item.objectID){
                return item
            }
        }
        
        return nil
    }
    
    func getSimilarItem(for shoppingItem: ShoppingItem) -> InventoryItem?{
        //define similarity of location --> auto integration of location
        let autoLocationIntegration = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_AUTO_LOCATION_INTEGRATION) ?? true
        
        
        //search for similar item
        for item in getAll(){
            //get values for title and unit
            guard let itemTitle = item.title?.lowercased() else {
                continue
            }
            
            guard let itemUnit = item.unit?.lowercased() else{
                continue
            }
            
            let title = shoppingItem.title ?? String.EMPTY
            let unit = shoppingItem.unit ?? String.EMPTY
            
            //compare values
            if autoLocationIntegration{
                if (title.lowercased() == itemTitle) && (unit.lowercased() == itemUnit) {
                    return item
                }
            }
            else{
                let itemLocation = item.location ?? String.EMPTY
                
                if (title.lowercased() == itemTitle) && (unit.lowercased() == itemUnit) && (itemLocation.isBlankOrEmpty()) {
                    return item
                }
            }
            
        }
        
        return nil
    }
}
