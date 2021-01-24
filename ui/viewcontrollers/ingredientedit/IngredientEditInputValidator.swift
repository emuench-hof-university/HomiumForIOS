//
//  IngredientEditInputValidator.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

class IngredientEditInputValidator : InputValidator{
    //type
    typealias I = (title : String, quantity: String, unit : String)
    
    //protocol functions
    func validateInput(input: (title : String, quantity: String, unit : String)) -> Bool {
        //checking for emptiness and blankness
        if (input.title.isEmpty || input.title.isBlank() || input.quantity.isEmpty || input.quantity.isBlank()){
            return false
        }
        
        //check unit
        if (input.unit.isEmpty || input.unit.isBlank()){
            return false
        }
            
        //checking for numeric quantity -> not necessary with keyboard type but implemented nevertheless to be safe
        guard let quantity = Double(input.quantity.replacingOccurrences(of: ",", with: ".")) else{
            return false
        }
            
        //checking for quantity greater than 0
        if(quantity <= 0.0){
            return false
        }
            
        // everything seems to be valid
        return true
    }
}
