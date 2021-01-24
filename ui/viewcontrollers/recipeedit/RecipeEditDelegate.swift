//
//  RecipeEditDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipeEditDelegate: NSObject, UITableViewDelegate {
    //fields
    var navigationPerformerDelegate : NavigationPerformerDelegate? = nil
    
    //custom header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //getting header
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewAddSectionHeader.reuseIdentifier) as? TableViewAddSectionHeader else{
            return nil
        }
        
        //section check
        if(section == 2){
            //ingredients
            header.title = ESSENTIAL_STRING_INGREDIENTS
            header.onAddButtonClickListener = {_ in
                self.navigationPerformerDelegate?.performSegue(identifier: SEGUE_RECIPE_EDIT_TO_INGREDIENT_EDIT, sender: nil)
            }
        }
        else if (section == 3){
            //descriptions
            header.title = ESSENTIAL_STRING_DESCRIPTIONS
            header.onAddButtonClickListener = {_ in
                self.addDescription(tableView: tableView)
            }
        }
        else{
            return nil
        }
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 2 || section == 3){
            return tableView.sectionHeaderHeight
        }
        else{
            return 0
        }
        
        //return tableView.headerView(forSection: section)?.frame.size.height ?? 0
    }
    
    //react on row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
            case 3: onDescriptionCellTouched(in : tableView, at: indexPath)
            default:
                print("didSelectRow with invalid params");
        }
    }
    
    private func onDescriptionCellTouched(in tableView: UITableView, at indexPath: IndexPath){
        for idx in 0..<tableView.numberOfRows(inSection: indexPath.section){
            if let descCell = tableView.cellForRow(at: IndexPath(row: idx, section: indexPath.section)) as? RecipeEditDescriptionCell{
                descCell.closeKeyboard()
            }
        }
    }
    
    //swipe actions
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActions(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActions(tableView, indexPath: indexPath)
    }
    
    private func swipeActions(_ tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let deleteAction = UIContextualAction(style: .destructive, title: ESSENTIAL_STRING_DELETE, handler: {(action,view, completionHandler) in
            
            if let datasource = tableView.dataSource as? RecipeEditDataSource{
                let sucess = datasource.deleteIngredientAtIndex(tableView: tableView, index: indexPath.row);
                return completionHandler(sucess)
            }
        })
        
        deleteAction.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    //help functions
    //function for adding a description
    private func addDescription(tableView: UITableView){
        //get datasource
        guard let datasource = tableView.dataSource as? RecipeEditDataSource else{
            return
        }
        //add new data
        datasource.addDescription(tableView: tableView, text: String.EMPTY)
        
        
    }
}
