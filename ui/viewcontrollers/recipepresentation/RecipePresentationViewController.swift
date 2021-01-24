//
//  RecipePresentationViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 04.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import UIKit
class RecipePresentationViewController : BaseViewController, PreviousViewControllerDelegate{
    //fields
    let datasource = RecipePresentationDataSource()
    var dataHandler : RecipePresentationDataHandler? = nil
    var previousVCDelegate : PreviousViewControllerDelegate? = nil
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var imgRecipe: UIImageView!
    
    //actions
    @IBAction func btnDeleteTouched(_ sender: UIBarButtonItem) {
        
        let deleteQuestionAllowed = HomiumSettings.instance.getUserSetting(key: USER_SETTING_RECIPE_DELETE_QUESTION_ALLOWED) ?? true
        
        if deleteQuestionAllowed{
            showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_SURE_DELETE_RECIPE.replacingOccurrences(of: "#", with: title ?? String.EMPTY), onYes: {
                self.doDeleteAction()
            }, onNo: {}, isDestructiveOperation: true)
        }
        else{
            doDeleteAction()
        }
        
        
    }
    
    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            datasource.changeViewSection(of: tableView, to: RecipePresentationDataSource.RecipePresentationViewSegment.INGREDIENTS)
        }
        else if sender.selectedSegmentIndex == 1{
            datasource.changeViewSection(of: tableView, to: RecipePresentationDataSource.RecipePresentationViewSegment.DESCRIPTIONS)
        }
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        //init code
        datasource.dataHandler = dataHandler
        datasource.onPictureDidChange = { img in
            self.imgRecipe.image = img
        }
        tableView.dataSource = datasource
        
        //init gui
        initGuiComponents()
    }
    
    //protocol functions
    func viewDidResume() {
        //reload data
        datasource.loadDataFromModel()
        tableView.reloadData()
        initGuiComponents()
        
        //pass reload to previeous VC
        previousVCDelegate?.viewDidResume()
    }
    
    //functions
    private func initGuiComponents(){
        title = datasource.title
        //TODO: Implement image loading
        imgRecipe.image = datasource.image
    }
    
    private func doDeleteAction(){
        let sucess = dataHandler?.delete() ?? false
        
        if sucess{
            previousVCDelegate?.viewDidResume()
            navigationController?.popViewController(animated: true)
        }
        else{
            showMessage(title: ESSENTIAL_STRING_ERROR, msg: MESSAGE_INTERNAL_ERROR)
        }
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == SEGUE_RECIPE_PRESENTATION_TO_RECIPE_EDIT){
            if let destination = segue.destination as? RecipeEditViewController {
                destination.previousVCDelegate = self
                destination.dataHandler = RecipeEditDataHandler(recipeId: dataHandler?.id)
            }
        }
        else if(segue.identifier == SEGUE_RECIPE_PRESENTATION_TO_RECIPE_DESCRIPTION_PRESENTATION){
            if let destination = segue.destination as? RecipeDescriptionPresentationViewController{
                guard let senderCell = sender as? RecipePresentationDescriptionCell else{
                    return
                }
                
                let showDescr = datasource.getDescriptionAt(index: tableView.indexPath(for: senderCell)?.row ?? -1) ?? String.EMPTY
                
                destination.dataHandler = RecipeDescriptionPresentationDataHandler(description: showDescr)
            }
        }
    }
}
