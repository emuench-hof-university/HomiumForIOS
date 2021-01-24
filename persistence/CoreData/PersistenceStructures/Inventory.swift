//
//  Inventory.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class Inventory : PersistenceHandler{
    
    private var data : [NSManagedObjectID : InventoryItem] = [:]
    
    var count : Int {
        get{
            return data.values.count
        }
    }
    
    
    func add(element: InventoryItem) -> Bool{
        guard let context = element.managedObjectContext else {
            return false
        }
        
        if let _ = data[element.objectID] {
            return false
        }
        else{
            //this is the only place where the values are valid to be inserted
            let sucess = syncWithPersistenceLayer(context: context)
            
            if sucess {
                data[element.objectID] = element
            }
            return sucess
        }
    }
    
    func delete(at id: NSManagedObjectID) -> InventoryItem?{
        guard let deleted = data[id] else{
            return nil
        }
        
        guard let context = deleted.managedObjectContext else{
            return nil
        }
        
        context.delete(deleted)
        let sucess = syncWithPersistenceLayer(context: context)
        if sucess {
            return data.removeValue(forKey: id)
        }
        else{
            return nil
        }
    }
    
    func get(_ id : NSManagedObjectID) -> InventoryItem?{
        return data[id]
    }
    
    func clear(){
        data.removeAll()
    }
    
    func getAll() ->[InventoryItem]{
        loadData()
        return Array(data.values)
    }
    
    func update(id: NSManagedObjectID, params: (title: String, quantity: Double, unit: String, location: String)) -> Bool {
        guard let element = data[id] else {
            return false
        }
        
        guard let context = element.managedObjectContext else{
            return false
        }
        
        //saving old values for security
        let oldValues = (element.objectID, element.title, element.quantity, element.unit, element.location)
        
        //assinging values
        element.title = params.title
        element.quantity = params.quantity
        element.unit = params.unit
        element.location = params.location
        
        let sucess = syncWithPersistenceLayer(context: context)
        
        if !sucess{
            //revert changes if sync failed
            element.title = oldValues.1
            element.quantity = oldValues.2
            element.unit = oldValues.3
            element.location = oldValues.4
        }
        else{
            data[element.objectID] = element
        }
        
        return sucess
    }
    
    //protocol functions
    func loadData() -> Bool{
        //get Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return false
        }
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            
            let fetchResult = try context.fetch(InventoryItem.fetchRequest()) as! [InventoryItem]//NSFetchRequest<NSFetchRequestResult>(entityName: CORE_DATA_ENTITY_NAME_SHOPPINGITEM)
            
            fetchResult.forEach{ item in
                data[item.objectID] = item
            }
            return true
            
        }
        catch{
            print("Error with loading data")
            return false
        }
    }
    
    
    func syncWithPersistenceLayer(context: NSManagedObjectContext) -> Bool {
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    
}
