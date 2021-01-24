//
//  IngredientEditViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class IngredientEditViewController : BaseViewController{
    
    //fields
    private let inputValidator = IngredientEditInputValidator()
    
    var dataHandler : IngredientEditDataHandler? = nil
    var previewsVCDelegate : PreviousViewControllerDataTransferDelegate? = nil
    
    //outlets
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var unitPicker: UnitPicker!
    @IBOutlet weak var btnDelete: RoundedButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    //actions

    @IBAction func btnDeleteTouched(_ sender: RoundedButton) {
        dataHandler?.delete()
        finishWithResult()
    }
    
    @IBAction func btnSaveTouched(_ sender: UIBarButtonItem) {
        //validate input
        let title = txtTitle.text ?? String.EMPTY
        let quantity = txtQuantity.text ?? String.EMPTY
        let unit = unitPicker.selectedUnit() ?? String.EMPTY
        
        let isValidInput = inputValidator.validateInput(input: (title: title, quantity: quantity, unit: unit))
        
        if isValidInput{
            let sucess = dataHandler?.putData(data: (title: title, quantity: quantity, unit: unit)) ?? false
            
            if sucess {
                finishWithResult()
            }
            else{
                showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
            }
        }
        else{
            showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INVALID_INGREDIENT_PARAMETERS)
        }
    }
    
    @IBAction func backgroundTouched(_ sender: UIControl) {
        txtQuantity.resignFirstResponder()
        txtTitle.resignFirstResponder()
    }
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup of text components
        txtTitle.delegate = self
        txtQuantity.delegate = self
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
        
        //get data from datahandler
        initGuiComponents()
    }
    
    //function
    func finishWithResult(){
        previewsVCDelegate?.onViewDataTransfered(data: dataHandler?.dataPackage ?? [:])
        previewsVCDelegate?.viewDidResume()
        navigationController?.popViewController(animated: true)
    }
    
    //help functions
    private func initGuiComponents(){
        if let data = dataHandler?.getData(){
            //set title
            title = ESSENTIAL_HEADLINE_EDIT_INGREDIENT
            //set data in gui
            txtTitle.text = data.title
            txtQuantity.text = data.quantity
            unitPicker.selectRow(unit: data.unit)
        }
        else{
            btnDelete.isHidden = true
        }
    }
    
}
