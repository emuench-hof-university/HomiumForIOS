//
//  InventoryItemEditDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData
import UIKit

class InventoryItemEditDataHandler : DataHandler{
   
    //fields
    private let id : NSManagedObjectID?
    private let dao : InventoryDao = DataStorage.inventoryDao
    
    //init
    init(id: NSManagedObjectID?){
        self.id = id
    }
    
    //type
    typealias T = (title: String, location : String, quantity: String, unit: String)
    
    //protocol functions
    func getData() ->(title: String, location : String, quantity: String, unit: String)? {
        
        //get no nil id
        guard let uid = id else{
            return nil
        }
        
        //get non nil-item
        guard let item = dao.get(id: uid) else{
            return nil
        }
        
        //format & return data
        return (title: item.title ?? String.EMPTY, location: item.location ?? String.EMPTY, quantity: item.quantity.description, unit : item.unit ?? String.EMPTY)
    }
    
    func putData(data: (title: String, location : String, quantity: String, unit: String)) -> Bool {
        
        //check context
        guard let context = getContext() else{
            return false
        }
    
        //create values
        let title = data.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let quantity = Double(data.quantity) else{
            return false
        }
        let unit = data.unit
        let location = data.location.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //check whether to update or to insert (if there is a similar item, the similar one is updated)
        if let uid = id {
            // id exists -> update
            if let similarItem = dao.getSimilarItem(id: uid, title: title, unit: unit, location: location){
                //update similar item
                let updatesucess = dao.update(id: similarItem.objectID, params: (title: similarItem.title ?? title, quantity: similarItem.quantity + quantity, unit: similarItem.unit ?? unit, location: similarItem.location ?? location))
                
                if updatesucess {
                    //delete original
                    dao.delete(id: uid)
                }
                
                return updatesucess
            }
            else {
                return dao.update(id: uid, params: (title: title, quantity: quantity, unit: unit, location: location))
            }
        }
        else{
            //check whether item  with same name and quantity already exists in database
            if let similarItem = dao.getSimilarItem(id: nil,title: title, unit: unit, location: location){
                //update similar item
                return dao.update(id: similarItem.objectID, params: (title: similarItem.title ?? title, quantity: similarItem.quantity + quantity, unit: similarItem.unit ?? unit, location: similarItem.location ?? location))
            }
            else{
                //insert new item
                //create instance
                let newElement = InventoryItem(entity: InventoryItem.entity(), insertInto: context)
                //assing values
                newElement.title = title
                newElement.quantity = quantity
                newElement.unit = unit
                newElement.location = location
                
                //insert
                return dao.insert(element: newElement)
            }
        }
    }
    
    
    func delete()-> Bool{
        if let uid = id{
            let deletedElement = dao.delete(id: uid)
            //return whether there was a item to be deleted
            return deletedElement != nil
        }
        
        return false
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }

}
