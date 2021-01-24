//
//  UnitPickerDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class UnitPickerDataSource: NSObject, UIPickerViewDataSource {
    
    private let units = Units.getTitles()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return units.count
    }
    
    func getValue(row: Int) -> String? {
        if(row >= 0 && row < units.count){
            return units[row]
        }
        else{
            return nil
        }
    }
    

}
