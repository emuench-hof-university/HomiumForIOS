//
//  UnitPicker.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class UnitPicker: UIPickerView {
    
    private let unitDataSource = UnitPickerDataSource()
    private let unitDelegate = UnitPickerDelegate()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUnitData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUnitData()
    }
    
    //functions
    func selectRow(unit: Units, animated: Bool = true){
        let rowIdx = Units.allCases.firstIndex(of: unit) ?? 0
        selectRow(rowIdx, inComponent: 0, animated: animated)
    }
    
    func selectRow(unit: String, animated: Bool = true){
        let unitVal = Units.valueOf(unit) ?? Units.ITEM
        selectRow(unit: unitVal,animated: animated)
    }
    
    func selectedUnit() -> String? {
        return unitDataSource.getValue(row: selectedRow(inComponent: 0))
    }
    
    //help functions
    private func initUnitData(){
        self.dataSource = unitDataSource
        self.delegate = unitDelegate
    }
}
