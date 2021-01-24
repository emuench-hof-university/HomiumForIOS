//
//  ShoppingListDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 22.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListDelegate: NSObject, UITableViewDelegate {
    //delegates
    var messageDelegate: MessageDelegate? = nil
    var navigationPerformerDelegate : NavigationPerformerDelegate? = nil
    private let transferHandler = ShoppingInventoryTransferDataHandler()
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier) as? ResizeableTableViewSectionHeader else{
            return nil
        }
        
        guard let dataSource = tableView.dataSource as? ShoppingListDataSource else{
            return nil
        }
        
        header.title = dataSource.getSectionTitle()
        return header
    }
    
    //swipe actions configuration
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfiguration(tableView: tableView,indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfiguration(tableView: tableView,indexPath: indexPath)
    }
    
    private func swipeActionConfiguration(tableView : UITableView,indexPath: IndexPath) -> UISwipeActionsConfiguration{
        //delete action
        let deleteAction = UIContextualAction(style: .destructive, title: ESSENTIAL_STRING_DELETE, handler: {(action,view, completionHandler) in
            tableView.beginUpdates()
            //perform delete
            
            if let dataSource = tableView.dataSource as? ShoppingListDataSource{
                // define delete
                /*let delete : () -> Void = {
                    let sucess = dataSource.dataHandler.deleteWithId(id: dataSource.getIdAtIndex(index: indexPath.row))
                    if(sucess){
                        //reload data
                        dataSource.reloadData()
                        //refresh view
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        //ajust section title
                        tableView.headerView(forSection: 0)?.textLabel?.text = dataSource.getSectionTitle()
                    }
                    
                }*/
                
                if HomiumSettings.instance.getUserSetting(key: USER_SETTING_SHOPPING_DELETE_QUESTION_ALLOWED) ?? true{
                    //delete question allowed --> call delegate
                    self.messageDelegate?.showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_SURE_DELETE_SHOPPING.replacingOccurrences(of: "#", with: dataSource.getTitleAtIndex(index: indexPath.row)), onYes: {
                        //perform delete if user taps yes
                        let sucess = dataSource.dataHandler.deleteWithId(id: dataSource.getIdAtIndex(index: indexPath.row))
                        if sucess{
                            self.deleteInView(tableView: tableView, dataSource: dataSource, at: [indexPath])
                        }
                        
                    }, onNo: {}, isDestructiveOperation: true, noIsDestructiveToo: false)
                }
                else{
                    //simple delete
                    let sucess = dataSource.dataHandler.deleteWithId(id: dataSource.getIdAtIndex(index: indexPath.row))
                    if sucess{
                        self.deleteInView(tableView: tableView, dataSource: dataSource, at: [indexPath])
                    }
                }
                
                
            }
            tableView.endUpdates()
            return completionHandler(true)
        })
        deleteAction.backgroundColor = .systemRed
        
        //edit action
        let editAction = UIContextualAction(style: .normal, title: ESSENTIAL_STRING_EDIT, handler: {(action,view, completionHandler) in
            //update
            self.navigationPerformerDelegate?.performSegue(identifier: SEGUE_SHOPPINGLIST_TO_EDIT, sender: tableView.cellForRow(at: indexPath))
            return completionHandler(true)
        })
        editAction.backgroundColor = UIColor.colorAccent ?? UIColor.systemBlue
        return UISwipeActionsConfiguration(actions: [deleteAction,editAction])
    }
    
    //cell click action
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        //perform update of item
        if let dataSource = tableView.dataSource as? ShoppingListDataSource{
            let sucess = dataSource.dataHandler.changeSelectedState(id: dataSource.getIdAtIndex(index: indexPath.row))
            
            if(sucess){
                dataSource.reloadAtIndex(index: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        tableView.endUpdates()
    }
    
    //delete action
    private func deleteInView(tableView: UITableView, dataSource : ShoppingListDataSource, at indexPaths: [IndexPath]){
        //reload data
        dataSource.reloadData()
        //refresh view
        tableView.deleteRows(at: indexPaths, with: .automatic)
        //ajust section title
        (tableView.headerView(forSection: 0) as? ResizeableTableViewSectionHeader)?.title = dataSource.getSectionTitle()
        tableView.headerView(forSection: 0)?.setNeedsLayout()
    }
    
    //shopping inventory transfer
    func onDataTransfer(in tableView: UITableView){
        //get datasource
        guard let datasource = tableView.dataSource as? ShoppingListDataSource else{
            return
        }
        
        //get selected items
        let selections = datasource.getSelectedProductsWithIndex()
        
        if selections.count == 0{
            //no selection --> does not make sense to transfer anything
            return
        }
        
        let indices = selections.map{
            return $0.idx
        }
        
        let values = selections.map{
            return $0.value
        }
        
        //get preferences
        let inventoryImportOption = InventoryImportOptions.getByIdOrDefault(id: HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_IMPORT_OPTIONS) ?? String.EMPTY)
        let deleteQuestionAllowed = HomiumSettings.instance.getUserSetting(key: USER_SETTING_SHOPPING_DELETE_QUESTION_ALLOWED) ?? true
        
        if inventoryImportOption == .ASK_EVERYTIME{
            askedTransfer(tableView: tableView, indices: indices, data: values, deleteQuestion: deleteQuestionAllowed, dataSource: datasource)
        }
        else if inventoryImportOption == .DO_ALWAYS {
            simpleTransfer(tableView: tableView, indices: indices, data: values, dataSource: datasource)
        }
        else if inventoryImportOption == .DO_NEVER{
            deleteTransfer(tableView: tableView, deleteQuestion: deleteQuestionAllowed, indices: indices, data: values, dataSource: datasource)
        }
        
        
    }
    
    private func askedTransfer(tableView : UITableView, indices: [Int], data: [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)], deleteQuestion: Bool, dataSource : ShoppingListDataSource){
        
        messageDelegate?.showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_TRANSFER_SHOPPING_INVENTORY, onYes: {
            self.simpleTransfer(tableView: tableView, indices: indices, data: data, dataSource: dataSource)
        }, onNo: {
            self.deleteTransfer(tableView: tableView, deleteQuestion: deleteQuestion, indices: indices, data: data, dataSource: dataSource)
        }, isDestructiveOperation: false, noIsDestructiveToo: !deleteQuestion)
    }
    
    private func simpleTransfer(tableView : UITableView, indices: [Int], data: [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)], dataSource : ShoppingListDataSource){
        tableView.beginUpdates()
        let sucess = self.transferHandler.transfer(src: data)
        if sucess{
            //delete in view
            self.deleteInView(tableView: tableView, dataSource: dataSource, at: indices.map{IndexPath(row: $0, section: 0)})
            
            //inform inventory view
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_INVENTORY_ITEMS_IMPORTED_FROM_SHOPPINGLIST), object: nil, userInfo: nil)
        }
        
        tableView.endUpdates()
    }
    
    private func deleteTransfer(tableView: UITableView, deleteQuestion: Bool, indices: [Int], data: [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)], dataSource: ShoppingListDataSource){
        if deleteQuestion{
            self.messageDelegate?.showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_DELETE_SELECTED_SHOPPINGITEMS, onYes: {
                tableView.beginUpdates()
                for dataIndex in data.indices{
                    let sucess = dataSource.dataHandler.deleteWithId(id: data[dataIndex].id)
                    
                    if sucess{
                        self.deleteInView(tableView: tableView, dataSource: dataSource, at: [IndexPath(row: indices[dataIndex], section: 0)])
                    }
                }
                //inform inventory view
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_INVENTORY_ITEMS_IMPORTED_FROM_SHOPPINGLIST), object: nil, userInfo: nil)
                tableView.endUpdates()
            }, onNo: {}, isDestructiveOperation: true, noIsDestructiveToo: false)
        }
        else{
            tableView.beginUpdates()
            for dataIndex in data.indices{
                let sucess = dataSource.dataHandler.deleteWithId(id: data[dataIndex].id)
                
                if sucess{
                    self.deleteInView(tableView: tableView, dataSource: dataSource, at: [IndexPath(row: indices[dataIndex], section: 0)])
                }
            }
            //inform inventory view
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_INVENTORY_ITEMS_IMPORTED_FROM_SHOPPINGLIST), object: nil, userInfo: nil)
            tableView.endUpdates()
        }
    }
    
}
