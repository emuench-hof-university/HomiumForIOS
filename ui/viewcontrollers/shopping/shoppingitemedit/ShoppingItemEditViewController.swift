//
//  ShoppingItemEditViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 16.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ShoppingItemEditViewController: BaseViewController {
    
    //fields
    private let inputValidator = ShoppingItemEditInputValidator()
    var dataHandler : ShoppingItemEditDataHandler? = nil
    var previousVC : PreviousViewControllerDelegate? = nil
    
    //outlets
    @IBOutlet private weak var txtTitle: UITextField!
    @IBOutlet private weak var txtQuantity: UITextField!
    @IBOutlet private weak var unitpicker: UnitPicker!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var btnDelete: RoundedButton!
    
    
    //actions
    @IBAction private func backgroundTouched(_ sender: UIControl) {
        txtTitle.resignFirstResponder()
        txtQuantity.resignFirstResponder()
    }
    
    @IBAction private func btnSaveTouched(_ sender: UIBarButtonItem) {
        //check if data is valid
        let title = txtTitle.text ?? String.EMPTY
        let quantity = txtQuantity.text ?? String.EMPTY
        let unit = unitpicker.selectedUnit() ?? String.EMPTY
        let inputIsValid = inputValidator.validateInput(input: (title,quantity,unit))
        
        //react on whether input is valid or not
        if(inputIsValid){
            //check data handler
            guard let dH = dataHandler else {
                showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
                return
            }
            //let data handler do work
            let sucess = dH.putData(data: (title,quantity,unit))
            
            if sucess{
                finish()
            }
            else{
               showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
            }
        }
        else{
            showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INVALID_SHOPPING_PARAMETERS)
        }
    }
    
    @IBAction private func btnDeleteTouched(_ sender: RoundedButton) {
        
        if HomiumSettings.instance.getUserSetting(key: USER_SETTING_SHOPPING_DELETE_QUESTION_ALLOWED) ?? true{
            //delete question allowed
            showAlertDialog(msg: MESSAGE_QUESTION_SURE_DELETE_SHOPPING.replacingOccurrences(of: "#", with: txtTitle.text ?? String.EMPTY), onYes: {
                let sucess = self.dataHandler?.delete() ?? false
                if sucess{
                    self.finish()
                }
                else{
                    self.showMessage(title: ESSENTIAL_STRING_ERROR, msg:MESSAGE_DELETE_FAILED)
                }
            },onNo:{},isDestructiveOperation: true)
        }
        else{
            //simple delete
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
        //UI SETUP
        //setup text fields for keyboard handling
        txtTitle.delegate = self
        txtQuantity.delegate = self
        
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
        
        //DATA SETUP
        initGUIComponents(dataHandler?.getData())
    }
    
    //navigation
    private func finish(){
        //pop vc
        navigationController?.popViewController(animated: true)
        previousVC?.viewDidResume()
    }
    
    //data setup
    private func initGUIComponents(_ data : (title: String, quantity: String, unit : String)?){
        if let inputData = data {
            //assign data to gui components
            txtTitle.text = inputData.title
            txtQuantity.text = inputData.quantity
            unitpicker.selectRow(unit: inputData.unit)
            
            //set title
            title = ESSENTIAL_HEADLINE_EDIT_SHOPPINGITEM
        }
        else{
            //Hide Button if there is no item yet to be deleted
            btnDelete.isHidden = true
            //set title
            title = ESSENTIAL_HEADLINE_ADD_SHOPPINGITEM
        }
    }
}
