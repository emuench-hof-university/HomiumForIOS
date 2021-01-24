//
//  IOSCoreExtensinos.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

extension String{
    static let EMPTY = ""
    
    var isNotEmpty : Bool {
        get{
            return !self.isEmpty
        }
    }
    
    func isBlank() -> Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func isBlankOrEmpty() -> Bool{
        return self.isBlank() || self.isEmpty
    }
    
    func isNotBlankOrEmpty() -> Bool{
        return !(self.isBlankOrEmpty())
    }
    
    func toIntegerStyle() -> String{
        guard let double = Double(self) else{
            return self
        }
        
        if double >= Double(Int.max) {
            return double.description
        }
        
        let int = Int(double)
        return (double - Double(int) == 0.0) ? int.description : double.description
    }
}

