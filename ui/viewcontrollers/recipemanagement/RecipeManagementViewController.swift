//
//  RecipeManagementViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RecipeManagementViewController: UICollectionViewController, PreviousViewControllerDelegate {
    //fields
    private let dataSource = RecipeManagementDataSource()
    private let delegate = RecipeManagementDelegate()
    
    //outlets
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var btnAddRecipe: UIBarButtonItem!
    
    @IBOutlet weak var btnEditSingleRecipe: UIBarButtonItem!
    //actions
    @IBAction func btnDeleteTouched(_ sender: UIBarButtonItem) {
        if isEditing{
            delegate.deleteMarkedRecipes(in: collectionView){
                self.setEditing(false, animated: true)
            }
            //
        }
    }
    @IBAction func btnEditTouched(_ sender: UIBarButtonItem) {
        //changing is Editing mode
        setEditing(!isEditing, animated: true)
    }
    
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        //register datasource
        dataSource.collectionView = collectionView
        collectionView.dataSource = dataSource
        
        //configure register delegate
        delegate.selectionChangeViewControllerCallback = { selectedItemCount in
            if (selectedItemCount == 0){
                self.btnEditSingleRecipe.isEnabled = false
                self.btnDelete.isEnabled = false
            }
            else if(selectedItemCount == 1){
                self.btnEditSingleRecipe.isEnabled = true
                self.btnDelete.isEnabled = true
            }
            else{
                self.btnEditSingleRecipe.isEnabled = false
                self.btnDelete.isEnabled = true
            }
        }
        delegate.messageDelegate = self
        collectionView.delegate = delegate

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func viewDidResume() {
        dataSource.loadDataFromModel()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

    //editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        //toggle btnAdd
        btnAddRecipe.isEnabled = !btnAddRecipe.isEnabled
        
        //toggle delete button depening on edit mode
        btnDelete.isEnabled = false
        
        //edit title
        title = (isEditing) ? ESSENTIAL_HEADLINE_RECIPES_EDITING : ESSENTIAL_HEADLINE_RECIPES_NORMAL
        
        //btn edit single recipe
        btnEditSingleRecipe.isEnabled = false
        
        //notify delegate + datasource about edit mode change
        delegate.isEditing = editing
        dataSource.setEditingState(to: editing, on: collectionView)
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == SEGUE_RECIPE_MANAGEMENT_TO_RECIPE_PRESENTATION && isEditing){
            return false
        }
        else{
            return true
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            
            if(identifier == SEGUE_RECIPE_MANAGEMENT_TO_RECIPE_EDIT_ADD){
                if let destination = segue.destination as? RecipeEditViewController{
                    destination.previousVCDelegate = self
                }
            }
            else if(identifier == SEGUE_RECIPE_MANAGEMENT_TO_RECIPE_EDIT_EDIT){
                if let destination = segue.destination as? RecipeEditViewController{
                    destination.previousVCDelegate = self
                    let id = dataSource.getIdForSelectedCell(in: collectionView)
                    destination.dataHandler = RecipeEditDataHandler(recipeId: id)
                    setEditing(false, animated: true)
                }
            }
            else if(segue.identifier == SEGUE_RECIPE_MANAGEMENT_TO_RECIPE_PRESENTATION){
                guard let senderCell = sender as? RecipeManagementItemCell else{
                    return
                }
                
                guard let id = dataSource.getIdForCell(senderCell: senderCell, in: collectionView) else{
                    return
                }
                
                if let destination = segue.destination as? RecipePresentationViewController{
                    destination.dataHandler = RecipePresentationDataHandler(id: id)
                    destination.previousVCDelegate = self
                }
            }
            
            tabBarController?.tabBar.isHidden = true
        }
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}
