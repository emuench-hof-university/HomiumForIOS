//
//  InventoryListDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class InventoryListDataHandler : DataHandler{
    //fields
    private let dao = DataStorage.inventoryDao
    
    //type
    typealias T = [(id: NSManagedObjectID,title: String, location : String, quantityDetails: String)]
    
    //protocol functions
    func getData() -> [(id: NSManagedObjectID, title: String, location: String, quantityDetails: String)]? {
        return dao.getAll().map{($0.objectID,$0.title ?? String.EMPTY,$0.location ?? String.EMPTY,"\($0.quantity.description.toIntegerStyle()) \($0.unit ?? String.EMPTY)")}
    }
    
    func putData(data: [(id: NSManagedObjectID, title: String, location: String, quantityDetails: String)]) -> Bool {
        //no put allowed so far
        return false
    }
    
    func delete() -> Bool{
        return dao.clear()
    }
    
    func deleteWithId(id : NSManagedObjectID?) -> Bool{
        guard let delId = id else{
            return false
        }
        
        return dao.delete(id: delId) != nil
    }
    
    func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    
}
