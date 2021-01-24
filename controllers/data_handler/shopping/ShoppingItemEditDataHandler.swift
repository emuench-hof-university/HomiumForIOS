//
//  ShoppingDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 18.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemEditDataHandler : DataHandler{
    
    typealias T = (title: String, quantity: String, unit : String)
    
    //fields
    private let id : NSManagedObjectID?
    private let dao : ShoppingDao = DataStorage.shoppingDao
    
    //init
    init(id: NSManagedObjectID?){
        self.id = id
    }
    
    //protocol functions
    func getData() -> (title: String, quantity: String, unit : String)?{
        //check if id is not nil
        guard let uid = id else {
            return nil
        }
        //get item from dao with non nil id
        guard let item = dao.get(id: uid) else {
            return nil
        }
        
        //translating shoppingitem into primitive data for ui
        let title = item.title ?? String.EMPTY
        let quantity = item.quantity.description
        let unit = item.unit ?? String.EMPTY
        
        return (title: title, quantity: quantity, unit: unit)
    }
    
    func putData(data : (title: String, quantity: String, unit : String)) -> Bool{
        //get context
        guard let context = getContext() else {
            print("DEBUG: Error. Can not execute put Data because of viewcontext is nil!!")
            return false
        }
        
        //create item
        /*
        guard let newEntity = NSEntityDescription.entity(forEntityName: CORE_DATA_ENTITY_NAME_SHOPPINGITEM, in: context) else{
            print("DEBUG: Error. Can not execute put Data because newEntity is nil!!")
            return false
        }*/
        
        guard let quantity = Double(data.quantity) else{
            return false
        }
        
        //perform operation with data
        if let uid = id{
            //assign basic values
            let params = (data.title,quantity,data.unit,dao.get(id: uid)?.selected ?? false)
            
            //do update in dao
            return dao.update(id: uid, params: params)
        }
        else{
            //assign basic values
            let item = ShoppingItem(entity: ShoppingItem.entity(), insertInto: context)
            item.title = data.title
            item.quantity = quantity
            item.unit = data.unit
            item.selected = false
            
            //calling dao
            return dao.insert(element: item)
        }
    }
    
    func delete()-> Bool{
        
        if let uid = id{
            let deletedElement = dao.delete(id: uid)
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
