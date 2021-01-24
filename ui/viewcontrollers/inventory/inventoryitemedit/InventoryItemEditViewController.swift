//
//  InventoryItemEditViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventoryItemEditViewController : BaseViewController{
    //fields
    private let inputValidator = InventoryItemEditInputValidator()
    var dataHandler : InventoryItemEditDataHandler? = nil
    var previousVC : PreviousViewControllerDelegate? = nil
    
    //outlets
    @IBOutlet private weak var txtTitle: UITextField!
    @IBOutlet private weak var txtLocation: UITextField!
    @IBOutlet private weak var txtQuantity: UITextField!
    @IBOutlet private weak var unitPicker: UnitPicker!
    @IBOutlet private weak var btnDelete: RoundedButton!
    @IBOutlet private weak var scrollView: UIScrollView!
   
    //actions
    @IBAction private func backgroundTouched(_ sender: UIControl) {
        txtQuantity.resignFirstResponder()
        txtLocation.resignFirstResponder()
        txtTitle.resignFirstResponder()
    }
    @IBAction private func btnSaveTouched(_ sender: UIBarButtonItem) {
        let title = txtTitle.text ?? String.EMPTY
        let quantity = txtQuantity.text ?? String.EMPTY
        let location = txtLocation.text ?? String.EMPTY
        let unit = unitPicker.selectedUnit() ?? String.EMPTY
        let isValid = inputValidator.validateInput(input: (title,location,quantity,unit))
        
        //react on whether input is valid or not
        if(isValid){
            //check data handler
            guard let dH = dataHandler else {
                showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
                return
            }
            //let data handler do work
            let sucess = dH.putData(data: (title: title,location: location,quantity: quantity,unit: unit))
            
            if sucess{
                finish()
            }
            else{
               showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
            }
            
        }
        else{
            showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INVALID_INVENTORY_PARAMETERS)
        }
        
    }
    @IBAction private func btnDeleteTouched(_ sender: RoundedButton) {
        let allowedToAskQuestion = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_DELETE_QUESTION_ALLOWED) ?? true
        
        if(allowedToAskQuestion){
            showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_SURE_DELETE_INVENTORY.replacingOccurrences(of: "#", with: txtTitle.text ?? String.EMPTY), onYes: {
                let sucess = self.dataHandler?.delete() ?? false
                if sucess{
                    self.finish()
                }
                else{
                    self.showMessage(title: ESSENTIAL_STRING_ERROR, msg:MESSAGE_DELETE_FAILED)
                }
            }, onNo: {}, isDestructiveOperation: true)
        }
        else{
            let sucess = self.dataHandler?.delete() ?? false
            if sucess{
                self.finish()
            }
            else{
                self.showMessage(title: ESSENTIAL_STRING_ERROR, msg:MESSAGE_DELETE_FAILED)
            }
        }
    
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup keyboard handling for textfields
        txtTitle.delegate = self
        txtQuantity.delegate = self
        txtLocation.delegate = self
        
        //calling function from SuperClass to create number Keyboard
        setupNumberKeyboard(forTextField: txtQuantity)
        
        //react to keyboard changes
        onKeyboardDidExpand = {
            self.scrollView.contentInset = $0
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        }
        
        onKeyboardDidHide = {
            self.scrollView.contentInset = $0
            self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        }
        
        //init with data if existing
        initGuiComponents(data: dataHandler?.getData())
    }
    
    private func initGuiComponents(data: (title: String, location : String, quantity: String, unit: String)?){
        if let values = data{
            txtTitle.text = values.title
            txtLocation.text = values.location
            txtQuantity.text = values.quantity
            unitPicker.selectRow(unit: values.unit)
            title = ESSENTIAL_HEADLINE_EDIT_INVENTORYITEM
        }
        else{
            btnDelete.isHidden = true
            title = ESSENTIAL_HEADLINE_ADD_INVENTORYITEM
        }
    }
    
    
    //navigation
    private func finish(){
        //pop vc
        navigationController?.popViewController(animated: true)
        previousVC?.viewDidResume()
    }
}
