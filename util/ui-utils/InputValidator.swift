//
//  InputValidator.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

protocol InputValidator{
    //a function that lets validator validate the gui components. Returns true if input is valid else false.
    associatedtype I
    func validateInput(input : I) -> Bool
}
