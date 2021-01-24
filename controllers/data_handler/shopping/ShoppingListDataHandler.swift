//
//  ShoppingListDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 22.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListDataHandler : DataHandler{
    //type
    typealias T = [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)]
    
    //fields
    private let dao : ShoppingDao = DataStorage.shoppingDao
    
    //protocol functions
    func getData() -> [(id: NSManagedObjectID, title: String, isSelected: Bool, quantityDetails: String)]?{
        
        return dao.getAll().map{($0.objectID,$0.title ?? String.EMPTY,$0.selected,"\($0.quantity.description.toIntegerStyle()) \($0.unit ?? String.EMPTY)")}
    }
    
    func getDataWithId(id: NSManagedObjectID?) -> (id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)?{
        guard let uid = id else {
            return nil
        }
        
        //get item
        guard let item = dao.get(id: uid) else {
            return nil
        }
        
        //get formatted data
        return (item.objectID,item.title ?? String.EMPTY,item.selected,"\(item.quantity.description.toIntegerStyle()) \(item.unit ?? String.EMPTY)")
        
    }
    
    func putData(data : [(id: NSManagedObjectID, title: String, isSelected: Bool, quantityDetails: String)]) -> Bool{
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
    
    func changeSelectedState(id: NSManagedObjectID?) -> Bool{
        return dao.changeSelectedState(id: id)
    }
    
    func getContext() -> NSManagedObjectContext?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
}
