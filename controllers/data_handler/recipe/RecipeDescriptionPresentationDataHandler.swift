//
//  RecipeDescriptionPresentationDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 06.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import CoreData

class RecipeDescriptionPresentationDataHandler : DataHandler{
    //type
    typealias T = String
    
    //fields
    private var description: String = String.EMPTY
    
    //init
    init(description : String){
        self.description = description
    }
    
    //protocol functions
    func getData() -> String? {
        return description
    }
    
    func putData(data: String) -> Bool {
        //not allowed here
        return false
    }
    
    func delete() -> Bool {
        //not allowed here
        return false
    }
    
    func getContext() -> NSManagedObjectContext? {
        //not needed here
        return nil
    }
}
