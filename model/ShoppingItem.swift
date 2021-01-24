//
//  File.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

class ShoppingItem{
    //fields
    let id = UUID()
    var title : String
    var quantity : Double
    var unit : String
    
    init(title: String, quantity: Double, unit : String){
        self.title = title
        self.quantity = quantity
        self.unit = unit
    }
}
