//
//  AlgorithmSortPickerDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventorySortAlgorithmSortPickerDelegate: NSObject, UIPickerViewDelegate{
    
    //fields
    var viewTarget : InventorySortAlgorithmTextField? = nil
    
    //functions
    //title for Row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let datasource = pickerView.dataSource as? InventorySortAlgorithmPickerDataSource {
            return datasource.get(index: row)?.title ?? String.EMPTY
        }
        else{
            return String.EMPTY
        }
    }
    
    //action with selected row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let datasource = pickerView.dataSource as? InventorySortAlgorithmPickerDataSource {
            if let algo = datasource.get(index: pickerView.selectedRow(inComponent: component)){
                HomiumSettings.instance.putUserSetting(value: algo.id, key: USER_SETTING_INVENTORY_SORT_ALGORITHM_ID)
                viewTarget?.text = algo.title
                
            }
        }
        
    }
}
