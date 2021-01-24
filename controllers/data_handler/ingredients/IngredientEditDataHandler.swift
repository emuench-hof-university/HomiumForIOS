//
//  IngredientEditDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//
//  ATTENTION: This datahandler is really unintelligent. It does not write and read any data to/from the database
//

import Foundation
import CoreData

class IngredientEditDataHandler : DataHandler{
    //type
    typealias T = (title: String, quantity: String, unit : String)
    
    //fields
    //private let id : NSManagedObjectID?
    //private let dao = DataStorage.recipeDao
    
    var dataPackage : [String:Any] = [:]
    
    //init
    init(package : [String:Any]){
        dataPackage = package
    }
    
    //protocol functions
    func getData() -> (title: String, quantity: String, unit: String)? {
        
        if(dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_INDEX] == nil){
            //if there is no index than there can't be any data
            return nil
        }
        
        if(dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_SHOULD_BE_DELETED] != nil){
            //there is no way data can be deleted before it should go to the editing screen
            //therefore the following opration corrigates wrong usage of this concept
            dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_SHOULD_BE_DELETED] = false
        }
        
        guard let title = dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_TITLE]  as? String else{
            return nil
        }
        
        guard let quantity = dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_QUANTITY]  as? String else{
            return nil
        }
        
        guard let unit = dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_UNIT]  as? String else{
            return nil
        }
        
        return (title: title, quantity: quantity.description, unit: unit)
    }
    
    func putData(data: (title: String, quantity: String, unit: String)) -> Bool {
        dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_TITLE] = data.title
        dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_QUANTITY] = data.quantity
        dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_UNIT] = data.unit
        return true
    }
    
    func delete() -> Bool {
        dataPackage[DATATRANSFER_KEY_INGREDIENTEDIT_SHOULD_BE_DELETED] = true
        return true
    }
    
    func getContext() -> NSManagedObjectContext? {
        return nil
    }
    
}
