//
//  RecipeEditViewControllerTableViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class RecipeEditViewController: UITableViewController, NavigationPerformerDelegate,PreviousViewControllerDataTransferDelegate {
    
    //fields
    var dataHandler = RecipeEditDataHandler(recipeId: nil)
    private var dataSource : RecipeEditDataSource = RecipeEditDataSource()
    private var delegate = RecipeEditDelegate()
    var previousVCDelegate : PreviousViewControllerDelegate? = nil
    
    //actions
    @IBAction private func btnSaveTouched(_ sender: UIBarButtonItem) {
        let success = dataSource.saveDataToModel()
        if success{
            previousVCDelegate?.viewDidResume()
            navigationController?.popViewController(animated: true)
        }
        else{
            showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INVALID_RECIPE_PARAMETERS)
        }
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //edit dataSource
        dataSource.tableView = tableView
        dataSource.dataHandler = dataHandler
        dataSource.chooserDelegate = self
        dataSource.imagePickerDelegate = ImagePickerDelegate(presenter: self)
        tableView.dataSource = dataSource
        
        //edit delegate
        delegate.navigationPerformerDelegate = self
        tableView.delegate = delegate
        
        //register custom header
        tableView.register(TableViewAddSectionHeader.self, forHeaderFooterViewReuseIdentifier: TableViewAddSectionHeader.reuseIdentifier)
        
        //set title
        title = (dataHandler.isEditMode) ? ESSENTIAL_HEADLINE_EDIT_RECIPE : ESSSENTIAL_HEADLINE_ADD_RECIPE
    }

    //protocol functions for NavigationPerformer
    func performSegue(identifier: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }

    //protocol functions for NavigationPerformerDelegate,PreviousViewControllerDataTransferDelegate
    func onViewDataTransfered(data: [String : Any]) {
        if let index = data[DATATRANSFER_KEY_INGREDIENTEDIT_INDEX] as? Int{
            if let _ = data[DATATRANSFER_KEY_INGREDIENTEDIT_SHOULD_BE_DELETED] {
                dataSource.deleteIngredientAtIndex(tableView: tableView, index: index)
            }
            else{
                //update
                dataSource.updateIngredient(tableView: tableView, index: index, data: data)
            }
        }
        else{
            //add
            dataSource.addIngredient(tableView: tableView, data: data)
        }
    }
    
    func viewDidResume() {
        //nothing to do here for now
    }

    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
            case SEGUE_RECIPE_EDIT_TO_INGREDIENT_EDIT: prepareRecipeEditToIngredientEditSegue(segue,sender)
            default:
                print("invalid segue in recipeedit")
        }
    }
        
    private func prepareRecipeEditToIngredientEditSegue(_ segue : UIStoryboardSegue, _ sender : Any?){
        if let destination = segue.destination as? IngredientEditViewController{
            destination.previewsVCDelegate = self
            
            //check sender if it was a cell
            if let senderCell = sender as? RecipeEditIngredientCell {
                let cellIndex = tableView.indexPath(for: senderCell)?.row ?? -1
                destination.dataHandler = IngredientEditDataHandler(package: dataSource.ingredientPackageForIndex(index: cellIndex))
            }
            else{
                destination.dataHandler = IngredientEditDataHandler(package: [:])
            }
            
        }
    }

}
