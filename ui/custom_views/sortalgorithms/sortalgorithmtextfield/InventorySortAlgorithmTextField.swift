//
//  SearchAlgorithmTextField.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventorySortAlgorithmTextField: UITextField {

    private let picker = InventorySortAlgorithmPicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize(){
        self.inputView = picker
        let toolbar = createToolbar(inputView: picker)
        self.inputAccessoryView = toolbar

        picker.algorithmDelegate.viewTarget = self
        
        //load value
        let id : String = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_SORT_ALGORITHM_ID) ?? InventorySortAlgorithms.alphabeticSort.id
        self.text = InventorySortAlgorithms.getById(id: id)?.title ?? InventorySortAlgorithms.alphabeticSort.title
        picker.selectRow(id: id)
        
    }
    
    private func createToolbar(inputView view: UIView) ->UIToolbar{
        //setup toolbar for done button
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn = UIBarButtonItem(title: ESSENTIAL_STRING_OK, style: .done, target: self, action: #selector(onDoneTouched))
        toolbar.setItems([flexSpace,doneBtn], animated: false)
        toolbar.sizeToFit()
        
        return toolbar
    }
    
    
    //keyboard reaction
    @objc private func onDoneTouched(){
        //sending notification that inventory needs to reload its data
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_SETTING_INVENTORY_SORT_CHANGED), object: nil, userInfo: nil)
        self.inputView?.resignFirstResponder()
        self.endEditing(false)
    }

}
