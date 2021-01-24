//
//  InventorySearchAlgorithmPicker.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventorySortAlgorithmPicker: UIPickerView {
    //fields
    let algorithmDataSource = InventorySortAlgorithmPickerDataSource()
    let algorithmDelegate = InventorySortAlgorithmSortPickerDelegate()
    
    //init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        dataSource = algorithmDataSource
        delegate = algorithmDelegate
        
        
    }
    
    //functions
    func selectedAlgorithmId() -> String{
        return algorithmDataSource.get(index: self.selectedRow(inComponent: 0))?.id ?? InventorySortAlgorithms.alphabeticSort.id
    }
    
    func selectRow(id : String){
        selectRow(InventorySortAlgorithms.allCases.map{$0.id}.firstIndex(of: id) ?? 0, inComponent: 0, animated: true)
    }
}
