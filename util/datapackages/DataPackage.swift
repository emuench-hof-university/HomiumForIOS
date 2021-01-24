//
//  DataPackage.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

class DataPackage {
    
    private var dataStore : [String:Any] = [:]
    
    func getData(key: String) -> Any?{
        return dataStore[key]
    }
    
    func putData(key: String, data: Any) -> Bool{
        dataStore[key] = data
        
    }
    
    func dataIsDeleted(key: String) -> Bool{
        
    }
    
    func isEmpty() -> Bool{
        
    }
}
