//
//  InventorySortAlgorithmPickerDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventorySortAlgorithmPickerDataSource: NSObject, UIPickerViewDataSource {
    
    private let data = InventorySortAlgorithms.allCases
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        data.count
    }
    
    func get(index: Int) -> InventorySortAlgorithms?{
        if(index < 0 || index >= data.count){
            return nil
        }
        else{
            return data[index]
        }
    }
    

}
