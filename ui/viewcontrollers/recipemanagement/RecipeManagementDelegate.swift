//
//  RecipeManagementDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeManagementDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //fields
    var isEditing = false
    var sectionHeaderView : RecipeManagementHeader? = nil
    var selectionChangeViewControllerCallback : (Int) -> Void = {_ in}
    var messageDelegate : MessageDelegate? = nil
    
    //determine size for item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInRow = (UIDevice.current.orientation.isLandscape) ? 3 : 2
        let sideSpacingBase = 1// value from interfacebuilder
        let sideSpacing = CGFloat(sideSpacingBase*2*numberOfItemsInRow)
    
        
        let width = collectionView.bounds.width/CGFloat(numberOfItemsInRow) - sideSpacing - 8
        let height = collectionView.bounds.width / CGFloat(numberOfItemsInRow)
        return CGSize(width: width, height: height)
    }
    
    //on cell clicked
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? RecipeManagementItemCell{
            if(isEditing){
                cell.toggleMarkedState()
                let markedCellsCount = markedCells(of: collectionView).count
                sectionHeaderView?.changeTextToCurrentMarkCount(markCount: markedCellsCount)
                selectionChangeViewControllerCallback(markedCellsCount)
            }
            
        }
    }
    
    func markedCells(of collectionView: UICollectionView) -> [RecipeManagementItemCell]{
        
        let res = collectionView.visibleCells.compactMap{$0 as? RecipeManagementItemCell}.filter{$0.isMarked}
        print("res is \(res.map{$0.lblTitle.text ?? "NO TITLE"}.description)");
        return res
    }
    
    func deleteMarkedRecipes(in collectionView : UICollectionView, onDone: @escaping () -> Void){
        guard let dataSource = collectionView.dataSource as? RecipeManagementDataSource else{
            return
        }
        
        let mrkCells = markedCells(of: collectionView)
        
        print(mrkCells.map{$0.lblTitle.text ?? "NO Title"}.description);
        
        //check for delete question
        let deleteQuestionAllowed = HomiumSettings.instance.getUserSetting(key: USER_SETTING_RECIPE_DELETE_QUESTION_ALLOWED) ?? true
        
        if (deleteQuestionAllowed && messageDelegate != nil){
            messageDelegate?.showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_SURE_DELETE_RECIPES.replacingOccurrences(of: "#", with: mrkCells.map{dataSource.getRecipeTitle(at: collectionView.indexPath(for: $0)?.row ?? -1) ?? String.EMPTY}.joined(separator: "\n")), onYes: {
                self.isEditing = false
                print(mrkCells.map{$0.lblTitle.text ?? "NO Title"}.description);
                dataSource.deleteRecipes(collectionView: collectionView, at: mrkCells.map{collectionView.indexPath(for: $0)?.row ?? -1})
                onDone()
            }, onNo: {}, isDestructiveOperation: true, noIsDestructiveToo: false)
            
            
        }
        else{
            isEditing = false
            dataSource.deleteRecipes(collectionView: collectionView, at: mrkCells.map{collectionView.indexPath(for: $0)?.row ?? -1})
            onDone()
        }
        
        
    }
    
}
