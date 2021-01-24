//
//  RecipeManagementDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class RecipeManagementDataSource: NSObject,UICollectionViewDataSource {
    //fields
    private var data : [(id: NSManagedObjectID, title: String, image: UIImage)] = []
    private let dataHandler = RecipeManagementDataHandler()
    private var isEditing = false
    var collectionView : UICollectionView? = nil
    
    //init
    override init() {
        super.init()
        //configure onImageLoaded listener from datahandler
        dataHandler.onImageLoadedAsync = {(index: Int, img: UIImage) -> Void in
            self.data[index].image = img
            self.collectionView?.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
        
        //load data
        loadDataFromModel()
    }
    
    //collection view functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //get cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeManagementItemCell", for: indexPath) as? RecipeManagementItemCell else{
            return UICollectionViewCell()
        }
        
        //configure cell
        cell.lblTitle.text = data[indexPath.row].title
        cell.markingPossible = isEditing
        cell.imgRecipe.image = data[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:RecipeManagementHeader.reuseIdentifier, for: indexPath) as? RecipeManagementHeader else{
            return UICollectionReusableView()
        }
        
        //assign header to delegate
        if let delegate = collectionView.delegate as? RecipeManagementDelegate{
            delegate.sectionHeaderView = sectionHeader
        }
        
        //configure header
        sectionHeader.setText(text: getSectionTitle())
        
        
        return sectionHeader
    }
    
    
    
    //functions
    func loadDataFromModel(){
        if let fetched = dataHandler.getData(){
            data = fetched
        }
    }
    
    func getSectionTitle() -> String{
        if(isEditing){
            if let colView = collectionView, let delegate = (collectionView?.delegate) as? RecipeManagementDelegate{
                return ESSENTIAL_PHRASE_HEADLINE_RECIPE_EDITINGMODE.replacingOccurrences(of: "#", with: delegate.markedCells(of: colView).count.description)
            }
            else{
                return ESSENTIAL_PHRASE_HEADLINE_RECIPE_EDITINGMODE.replacingOccurrences(of: "#", with: "0")
            }
            
            
        }
        else{
            if(data.count == 0){
                return MESSAGE_LOOKS_EMPTY
            }
            else if(data.count == 1){
                return ESSENTIAL_PHRASE_HEADLINE_RECIPE.replacingOccurrences(of: "Rezepte", with: "Rezept").replacingOccurrences(of: "#", with: "\(data.count)")
            }
            else{
                return ESSENTIAL_PHRASE_HEADLINE_RECIPE.replacingOccurrences(of: "#", with: "\(data.count)")
            }
        }
    }
    
    func setEditingState(to newEditingState: Bool, on collectionView: UICollectionView){
        isEditing = newEditingState
        collectionView.reloadData()
    }
    
    func getRecipeTitle(at index: Int) -> String?{
        if (index < 0 || index >= data.count){
            return nil
        }
        else{
            return data[index].title
        }
    }
    
    func deleteRecipes(collectionView: UICollectionView, at indices : [Int]) -> Bool{
        for idx in indices{
            if (idx < 0 || idx >= data.count){
                return false
            }
            let delSuc = dataHandler.delete(id: data[idx].id)
            
            if !delSuc{
                return false
            }
        }
        
        loadDataFromModel()
        //end editing state and do automatic reload of view
        setEditingState(to: false, on: collectionView)
        
        return true
    }
    
    func getIdForSelectedCell(in collectionView: UICollectionView) -> NSManagedObjectID?{
        if isEditing{
            guard let delegate = collectionView.delegate as? RecipeManagementDelegate else{
               return nil
            }
            
            let markedCells = delegate.markedCells(of: collectionView)
            
            if markedCells.count != 1{
                return nil
            }
            else{
                let index = collectionView.indexPath(for: markedCells[0])?.row ?? -1
                
                if (index < 0 || index >= data.count){
                    return nil
                }
                else{
                    return data[index].id
                }
            }
        }
        else{
            return nil
        }
    }
    
    func getIdForCell(senderCell: RecipeManagementItemCell, in collectionView: UICollectionView) -> NSManagedObjectID?{
        guard let indexPath = collectionView.indexPath(for: senderCell) else{
            return nil
        }
        
        if indexPath.row < 0 || indexPath.row >= data.count{
            return nil
        }
        else{
            return data[indexPath.row].id
        }
    }
    

}
