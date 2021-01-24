//
//  RecipeEditDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class RecipeEditDataSource: NSObject, UITableViewDataSource {
    //fields
    var dataHandler : RecipeEditDataHandler = RecipeEditDataHandler(recipeId: nil){
        didSet{
            loadDataFromModel()
            print("DataHandler did reload Data")
        }
    }
    
    var chooserDelegate : ChooserDialogDelegate? = nil
    var imagePickerDelegate: ImagePickerDelegate? = nil{
        didSet{
            imagePickerDelegate?.onPictureSelected = {img in
                self.image = img
            }
        }
    }
    
    var tableView : UITableView? = nil
    private let inputValidator = RecipeEditInputValidator()
    
    //init
    override init() {
        super.init()
        loadDataFromModel()
    }
    
    private var title : String = String.EMPTY
    private var image : UIImage = UIImage.noRecipeImage ?? UIImage(){
        didSet{
            if let tblView = self.tableView {
                self.reloadPictureCell(in: tblView)
            }
        }
    }
    private var ingredients : [(title: String, quantity: String, unit: String)] = []
    private var descriptions : [String] = []
    
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
            case 0 : return 1 // image section
            case 1 : return 1 // header section
            case 2 : return ingredients.count // ingredients section
            case 3 : return descriptions.count // descriptions section
            default : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
            case 0: return configuredPictureCell(tableView : tableView, forIndexPath: indexPath)
            case 1: return configuredHeaderCell(tableView : tableView, forIndexPath: indexPath)
            case 2: return configuredIngredientCell(tableView: tableView, forIndexPath: indexPath)
            case 3: return configuredDescriptionCell(tableView: tableView, forIndexPath: indexPath)
            default: return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    //functions
    func loadDataFromModel(){
        if let fetchedData = dataHandler.getData(){
            title = fetchedData.title
            image = fetchedData.image
            ingredients = fetchedData.ingredients
            descriptions = fetchedData.descriptions
        }
    }
    
    func saveDataToModel() -> Bool{
        let isValid = inputValidator.validateInput(input: (title: title, image: image , ingredients: ingredients, descriptions: descriptions))
        
        if isValid{
            return dataHandler.putData(data: (title: title, image: image, ingredients: ingredients, descriptions: descriptions))
        }
        else{
            return false
        }
        
    }
    
    
    //descriptions
    func addDescription(tableView : UITableView,text: String){
        descriptions.append(text)
        DispatchQueue.main.async {
            tableView.beginUpdates()
            //insert row
            tableView.insertRows(at: [IndexPath(row: self.descriptions.count-1, section: 3)], with: .automatic)
            tableView.endUpdates()
            //scroll to row
            let scrollIndex = self.numberOfDescriptions() - 1
            tableView.scrollToRow(at: IndexPath(row: scrollIndex, section: 3), at: .none, animated: true)
        }
        
        
    }
    
    func numberOfDescriptions() -> Int{
        return descriptions.count
    }
    
    //ingredients
    func addIngredient(tableView: UITableView, data: [String:Any]){
        //get values
        guard let title = data[DATATRANSFER_KEY_INGREDIENTEDIT_TITLE] as? String else{
            return
        }
        
        guard let unit = data[DATATRANSFER_KEY_INGREDIENTEDIT_UNIT] as? String else{
            return
        }
        
        guard let quantity = data[DATATRANSFER_KEY_INGREDIENTEDIT_QUANTITY] as? String else{
            return
        }
        
        ingredients.append((title: title, quantity: quantity.toIntegerStyle(),unit: unit))
        
        DispatchQueue.main.async {
            tableView.beginUpdates()
            //insert row
            tableView.insertRows(at: [IndexPath(row: self.ingredients.count-1, section: 2)], with: .automatic)
            tableView.endUpdates()
        }
        
    }
    
    func updateIngredient(tableView: UITableView,index: Int, data: [String: Any]){
        //get values
        guard let title = data[DATATRANSFER_KEY_INGREDIENTEDIT_TITLE] as? String else{
            return
        }
        
        guard let unit = data[DATATRANSFER_KEY_INGREDIENTEDIT_UNIT] as? String else{
            return
        }
        
        guard let quantity = data[DATATRANSFER_KEY_INGREDIENTEDIT_QUANTITY] as? String else{
            return
        }
        
        //update values
        ingredients[index] = (title: title, quantity: quantity.toIntegerStyle(),unit: unit)
        
        //update view
        DispatchQueue.main.async {
            tableView.reloadRows(at: [IndexPath(row: index, section: 2)], with: .automatic)
        }
    }
    
    func ingredientPackageForIndex(index: Int) -> [String:Any]{
        var package : [String:Any] = [:]
        
        if(index >= 0 && index < ingredients.count){
            let ingr = ingredients[index]
            package[DATATRANSFER_KEY_INGREDIENTEDIT_INDEX] = index
            package[DATATRANSFER_KEY_INGREDIENTEDIT_TITLE] = ingr.title
            package[DATATRANSFER_KEY_INGREDIENTEDIT_QUANTITY] = ingr.quantity
            package[DATATRANSFER_KEY_INGREDIENTEDIT_UNIT] = ingr.unit
        }
        return package
    }
    
    func deleteIngredientAtIndex(tableView: UITableView, index : Int) -> Bool{
        if(index < 0 || index >= ingredients.count){
            return false
        }
        else{
            ingredients.remove(at: index)
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: index, section: 2)], with: .automatic)
            tableView.endUpdates()
            return true
        }
    }
    
    //help functions
    private func configuredPictureCell(tableView : UITableView,forIndexPath indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeEditPictureCell") as? RecipeEditPictureCell else{
            return UITableViewCell()
        }
        
        cell.picture.image = image
        return cell
    }
    
    private func reloadPictureCell(in tableView: UITableView){
       tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    private func configuredHeaderCell(tableView : UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeEditHeaderCell") as? RecipeEditHeaderCell else{
            return UITableViewCell()
        }
        //configure cell
        cell.txtTitle.text = title
        cell.titleTextChangeListener = { txtField in
            self.title = txtField.text ?? String.EMPTY
        }
        cell.pictureButtonTouchedListener = {btn in
            guard let chooser = self.chooserDelegate else{
                return
            }
            
            chooser.showValueChooserDialog(title: ESSENTIAL_STRING_CHOOSE, msg: MESSAGE_CHOOSE_PICTURE_ACTION, values: PictureChooseOptions.getAllAvalibleCases(), onChoose: {value in
                
                
                if(value == PictureChooseOptions.TAKE_PICTURE_WITH_CAMERA){
                    //take new picture
                    self.imagePickerDelegate?.takePictureWithCamera()
                }
                else if (value == PictureChooseOptions.CHOOSE_PICTURE_FROM_GALLERY){
                    //choose from galery
                    self.imagePickerDelegate?.choosePictureFromGalery()
                }
                else if(value == PictureChooseOptions.REMOVE_PICTURE){
                    //remove picture
                    self.image = UIImage.noRecipeImage ?? UIImage()
                    self.reloadPictureCell(in: tableView)
                }
                
            }, onCancel: {}, sender: btn)
        }
        //return
        return cell
    }
    
    private func configuredIngredientCell(tableView : UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeEditIngredientCell") as? RecipeEditIngredientCell else{
            return UITableViewCell()
        }
        //configure cell
        cell.lblTitle.text = ingredients[indexPath.row].title
        let ingredient = ingredients[indexPath.row]
        cell.lblQuantityDetails.text = "\(ingredient.quantity) \(ingredient.unit)"
        //return
        return cell
    }
    
    private func configuredDescriptionCell(tableView : UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeEditDescriptionCell") as? RecipeEditDescriptionCell else{
            return UITableViewCell()
        }
        //configure cell
        cell.txtAreaDescriptionText.text = descriptions[indexPath.row]
        cell.lblIndex.text = (indexPath.row + 1).description
        cell.setOnDescriptionChangeListener{(txtArea: UITextArea) in
            self.descriptions[indexPath.row] = txtArea.text
            tableView.beginUpdates()
            tableView.endUpdates()
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        //return
        return cell
    }
    
    //functions for debugging purposes
    func debugPrint(){
        print("DEBUGGING RECIPEEDITDATASOURCE:")
        print("Title: \(title)")
        print("imagePath: \(image)")
        print("ingredients: \(ingredients.description)")
        print("descriptions: \(descriptions.description)")
    }
}
