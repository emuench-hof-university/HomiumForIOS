//
//  RecipeEditInputValidator.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 31.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeEditInputValidator : InputValidator{
    //type
    typealias I = (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String])
    
    //protocol functions
    func validateInput(input: (title: String, image: UIImage, ingredients: [(title: String, quantity: String, unit: String)], descriptions: [String])) -> Bool {
        //simple input validation
        //if validation should be more restricted that can later be added here
        return !(input.title.isEmpty || input.title.isBlank())
    }
}
