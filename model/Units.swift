//
//  Unit.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 09.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

enum Units : CaseIterable{
    
    //cases
    case ITEM
    case PACK
    case GRAM
    case KILOGRAM
    case LITRE
    case MILILITRE
    
    //computed properties
    var title : String {
        get{
            switch(self){
                case .ITEM: return "Stück"
                case .PACK : return "Packung"
                case .GRAM : return "Gramm"
                case .KILOGRAM: return "Kilogramm"
                case .LITRE : return "Liter"
                case .MILILITRE : return "Milliliter"
            }
        }
    }
    
    //Bounds for a middle quantity of a specific unit
    var bounds : (lowerbound: Double, upperbound: Double){
        get{
            switch(self){
            case .ITEM: return (lowerbound: 10.0, upperbound: 15.0)
                case .PACK : return (lowerbound: 4.0, upperbound: 10.0)
                case .GRAM : return (lowerbound: 100.0, upperbound: 1000.0)
                case .KILOGRAM: return (lowerbound: 2.0, upperbound: 5.0)
                case .LITRE : return (lowerbound: 2.0, upperbound: 4.0)
                case .MILILITRE : return (lowerbound: 100.0, upperbound: 1000.0)
            }
        }
    }
    
    //static properties
    static let unitConverter = UnitConverter()
    
    // static functions
    static func getTitles() -> [String]{
        return Units.allCases.map{$0.title}
    }
    
    static func valueOf(_ str : String) -> Units?{
        let results = Units.allCases.map{(unit : Units) -> (element: Units, title: String) in
            return (element: unit, title: unit.title)
        }.filter{
            $0.title == str
        }
        
        if results.isEmpty {
            return nil
        }
        else{
            return results[0].element
        }
    }
    
    static func quantityIndicatorColor(details : String) -> UIColor{
        //default value
        let defaultColor = UIColor.systemRed
        
        //get values
        let values = details.split(separator: " ").map{
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        //quantity
        guard let quantity = Double(values[0].description) else{
            return defaultColor
        }
        
        //unit
        guard let unit = Units.valueOf(values[1].description) else{
            return defaultColor
        }
        
        //check for bounds and return correct corresponding color
        if quantity >= unit.bounds.upperbound{
            return UIColor.systemGreen
        }
        else if quantity > unit.bounds.lowerbound{
            return UIColor.systemYellow
        }
        else{
            return defaultColor
        }
        
        
    }
    
    
    
}
