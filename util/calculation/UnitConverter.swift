//
//  UnitConverter.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

class UnitConverter{
    
    
    //functions
    func isConvertible(unit : Units) -> Bool{
        if(unit == Units.PACK || unit == Units.ITEM){
            return false
        }
        else{
            return true
        }
    }
    
    func isConvertible(unit: String) -> Bool{
        guard let value = Units.valueOf(unit) else{
            return false
        }
        
        return isConvertible(unit: value)
    }
    
    func convert(value : Double, unitOld : String, unitNew: String) -> Double{
        guard let new = Units.valueOf(unitNew) else{
            return value
        }
        return convert(value: value, unitOld: unitOld, unitNew: new)
    }
    
    func convert(value : Double, unitOld : String, unitNew: Units) -> Double{
       guard let old = Units.valueOf(unitOld) else{
            return value
        }
        
        return convert(value: value, unitOld: old, unitNew: unitNew)
    }
    
    func convert(value : Double, unitOld : Units, unitNew: Units) -> Double{
        if(!isConvertible(unit: unitOld) || !isConvertible(unit: unitNew)){
            return value
        }
        else {
            switch(unitNew){
                case .KILOGRAM : return convertToKilogram(value, unitOld)
                case .GRAM : return convertToGram(value, unitOld)
                case .LITRE : return convertToLitre(value, unitOld)
                case .MILILITRE : return convertToMillilitre(value, unitOld)
                default: return value
            }
        }
        
    }
    
    
    //help functions
    private func convertToKilogram(_ value: Double, _ oldUnit : Units) -> Double{
        switch oldUnit {
            case .GRAM: return value / 1000
            case .MILILITRE: return value / 1000
            default: return value
        }
    }
    
    private func convertToGram(_ value: Double, _ oldUnit : Units) -> Double{
       switch oldUnit {
            case .KILOGRAM: return value * 1000
            case .LITRE: return value * 1000
            default: return value
        }
    }
    
    private func convertToLitre(_ value: Double, _ oldUnit : Units) -> Double{
       switch oldUnit {
            case .GRAM: return value / 1000
            case .MILILITRE: return value / 1000
            default: return value
        }
    }
    
    private func convertToMillilitre(_ value: Double, _ oldUnit : Units) -> Double{
        switch oldUnit {
            case .KILOGRAM: return value * 1000
            case .LITRE: return value * 1000
            default: return value
        }
    }
}
