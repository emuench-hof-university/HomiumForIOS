//
//  InventoryDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventoryDelegate: NSObject, UITableViewDelegate {
    //delegates
    var messageDelegate: MessageDelegate? = nil
    
    //header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier) as? ResizeableTableViewSectionHeader else{
            return nil
            
        }
        
        guard let dataSource = tableView.dataSource as? InventoryDataSource else{
            return nil
        }
        
        header.title = dataSource.getSectionTitle()
        print("Section title is \(header.title)")
        return header
    }
    
    //swipe actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfiguration(tableView: tableView,indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return swipeActionConfiguration(tableView: tableView,indexPath: indexPath)
    }
    
    private func swipeActionConfiguration(tableView: UITableView,indexPath: IndexPath) -> UISwipeActionsConfiguration{
        let deleteAction = UIContextualAction(style: .destructive, title: ESSENTIAL_STRING_DELETE, handler: {(action,view, completionHandler) in
            tableView.beginUpdates()
            
            //delete item
            if let dataSource = tableView.dataSource as? InventoryDataSource{
                //delete closure
                let delete : () -> Void = {
                    let id = dataSource.getIdAtIndex(index: indexPath.row)
                    let sucess = dataSource.dataHandler.deleteWithId(id: id)
                
                    if(sucess){
                        //reload data
                        dataSource.reloadData()
                        //refresh view
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        //ajust section title
                        (tableView.headerView(forSection: 0) as? ResizeableTableViewSectionHeader)?.title = dataSource.getSectionTitle()
                        tableView.headerView(forSection: 0)?.setNeedsLayout()
                    }
                }
                
                let shallAskDeleteQuestion = HomiumSettings.instance.getUserSetting(key: USER_SETTING_INVENTORY_DELETE_QUESTION_ALLOWED) ?? true
                
                if shallAskDeleteQuestion {
                    self.messageDelegate?.showAlertDialog(title: ESSENTIAL_STRING_MESSAGE, msg: MESSAGE_QUESTION_SURE_DELETE_INVENTORY.replacingOccurrences(of: "#", with: dataSource.getTitleAtIndex(index: indexPath.row)), onYes: {delete()}, onNo: {}, isDestructiveOperation: true, noIsDestructiveToo: false)
                }
                else{
                    //simple delete
                    delete()
                }
                
            }
            tableView.endUpdates()
            return completionHandler(true)
        })
        
        deleteAction.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
