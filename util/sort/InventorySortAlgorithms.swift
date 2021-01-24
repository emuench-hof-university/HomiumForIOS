//
//  InventorySortAlgorithms.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

enum InventorySortAlgorithms : CaseIterable, CustomStringConvertible{
    //cases
    case alphabeticSort
    case quantitySort
    
    //computed properties
    var algorithm : (InventoryItem,InventoryItem) -> Bool{
        get{
            switch(self){
                case .alphabeticSort: return {(item1, item2) -> Bool in
                    return (item1.title?.lowercased() ?? String.EMPTY) < (item2.title?.lowercased() ?? String.EMPTY)
                }
                case .quantitySort : return {(item1, item2) -> Bool in
                    if item1.unit == item2.unit {
                        return item1.quantity < item2.quantity
                    }
                    else{
                        guard let unit1 = item1.unit else {
                            return false
                        }
                        guard let unit2 = item2.unit else{
                            return false
                        }
                        
                        let converter = Units.unitConverter
                        
                        if(!converter.isConvertible(unit: unit1) && !converter.isConvertible(unit: unit2)){
                            return unit1 == Units.ITEM.title
                        }
                        else if(converter.isConvertible(unit: unit1) && converter.isConvertible(unit: unit2)){
                            return converter.convert(value: item1.quantity, unitOld: unit1, unitNew: .GRAM) < converter.convert(value: item2.quantity, unitOld: unit2, unitNew: .GRAM)
                        }
                        else{
                            return !(converter.isConvertible(unit: unit1))
                        }
                        
                    }
                    
                    
                }
            }
        }
    }
    
    var id : String {
        get{
            switch self {
                case .alphabeticSort: return "SEARCH_ALGORITHM_0"
                case .quantitySort: return "SEARCH_ALGORITHM_1"
            }
        }
    }
    
    var shortDescription : String{
        get{
            switch self {
                case .alphabeticSort: return ESSENTIAL_STRING_ALPHABETIC
                case .quantitySort: return ESSENTIAL_STRING_QUANTITY
            }
        }
    }
    
    var title : String {
        get{
            switch self {
                case .alphabeticSort: return "Alphabetisch sortiert"
                case .quantitySort: return "Nach Menge sortiert"
            }
        }
    }
    
    //protocol variables
    var description: String{
        get{
            return self.title
        }
    }
    
    //static functions
    static func getById(id: String) -> InventorySortAlgorithms?{
        switch id {
            case InventorySortAlgorithms.alphabeticSort.id: return InventorySortAlgorithms.alphabeticSort
            case InventorySortAlgorithms.quantitySort.id : return InventorySortAlgorithms.quantitySort
            default: return nil
        }
    }
}
