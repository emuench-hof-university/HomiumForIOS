//
//  InventoryImportOptions.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 25.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

enum InventoryImportOptions: CaseIterable, CustomStringConvertible{
    //cases
    case ASK_EVERYTIME
    case DO_ALWAYS
    case DO_NEVER
    
    //static functions
    static func getById(id: String) -> InventoryImportOptions?{
        for opt in InventoryImportOptions.allCases{
            if opt.id == id{
                return opt
            }
        }
        return nil
    }
    
    static func getByIdOrDefault(id: String) -> InventoryImportOptions{
        if let opt = getById(id: id){
            return opt
        }
        else{
            return defaultOption()
        }
    }
    
    static func defaultOption() -> InventoryImportOptions{
        return .ASK_EVERYTIME
    }
    
    //fields
    var description: String{
        get{
            switch self{
                case .ASK_EVERYTIME: return ESSENTIAL_PHRASE_INVENTORYIMPORT_ASK_EVERYTIME
                case .DO_ALWAYS: return ESSENTIAL_PHRASE_INVENTORYIMPORT_DO_ALWAYS
                case .DO_NEVER : return ESSENTIAL_PHRASE_INVENTORYIMPORT_DO_NEVER
            }
        }
    }
    
    var shortDescription : String{
       get{
            switch self{
                case .ASK_EVERYTIME: return ESSENTIAL_STRING_ASK
                case .DO_ALWAYS: return ESSENTIAL_STRING_ALWAYS
                case .DO_NEVER : return ESSENTIAL_STRING_NEVER
            }
        }
    }
    
    var id: String{
        get{
            switch self{
                case .ASK_EVERYTIME: return "inventoryimportoption_ask_everytime"
                case .DO_ALWAYS: return "inventoryimportoption_do_always"
                case .DO_NEVER : return "inventoryimportoption_do_never"
            }
        }
    }
    
    
    
}
