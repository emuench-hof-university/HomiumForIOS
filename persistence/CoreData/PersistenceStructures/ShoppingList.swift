//
//  ShoppingList.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData
import UIKit

class ShoppingList : PersistenceHandler{
    
    //fields
    private var data : [ShoppingItem]
    
    var count : Int {
        get{
            return data.count
        }
    }
    
    //init
    init(data : [ShoppingItem] = []){
        self.data = data
    }
    
    //functions
    func get(id: NSManagedObjectID) -> ShoppingItem?{
        var result : ShoppingItem? = nil
        for el in data {
            if(el.objectID == id){
                result = el
                break
            }
        }
        return result
    }
    
    func add(element: ShoppingItem) -> Bool{
        if !(data.contains(element)){
            guard let context = element.managedObjectContext else {
                return false
            }
            let sucess = syncWithPersistenceLayer(context: context)
            if(sucess){
                data.append(element)
                return true
            }
            else{
                return false
            }
            
        }
        else{
            return false
        }
    }
    
    func delete(id : NSManagedObjectID) -> ShoppingItem?{
        guard let element = get(id: id) else {
            return nil
        }
        
        guard let context = element.managedObjectContext else{
            return nil
        }
        
        guard let index = data.firstIndex(of: element) else{
            return nil
        }
        
        context.delete(element)
        let sucess = syncWithPersistenceLayer(context: context)
        if(sucess){
            return data.remove(at: index)
        }
        else{
            return nil
        }
    }
    
    /*func appendData(elements: [ShoppingItem]){
        if !(elements.isEmpty){
            for element in elements{
                add(element: element)
            }
        }
    }*/
    
    func getAll() -> [ShoppingItem]{
        loadData()
        return data
    }
    
    func loadData() -> Bool{
        //get Context
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return false
        }
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            
            data = try context.fetch(ShoppingItem.fetchRequest()) as [ShoppingItem]//NSFetchRequest<NSFetchRequestResult>(entityName: CORE_DATA_ENTITY_NAME_SHOPPINGITEM)
            return true
            
        }
        catch{
            print("Error with loading data")
            return false
        }
    }
    
    //this function is prefered instead of update for changing the selected state, because only one state has to be changed
    func changeSelectedState(id: NSManagedObjectID) -> Bool{
        //get element
        guard let element = get(id: id) else {
            return false
        }
        
        //get context
        guard let context = element.managedObjectContext else {
            return false
        }
        
        //change selected state
        element.selected = !(element.selected)
        
        return syncWithPersistenceLayer(context: context)
        
        
    }
    
    func update(id: NSManagedObjectID, newTitle : String, newQuantity: Double,newUnit : String, newSelectedState : Bool) -> Bool{
        //get element
        guard let element = get(id: id) else {
            return false
        }
        
        //get context
        guard let context = element.managedObjectContext else {
            return false
        }
        
        //assigning values
        element.title = newTitle
        element.quantity = newQuantity
        element.selected = newSelectedState
        element.unit = newUnit
        
        return syncWithPersistenceLayer(context: context)
        
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
