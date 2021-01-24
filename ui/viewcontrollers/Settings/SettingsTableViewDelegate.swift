//
//  SettingsTableViewDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 13.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class SettingsTableViewDelegate: NSObject, UITableViewDelegate {

    //fields
    var vc : SettingsViewController? = nil
    
    //functions
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier) as? ResizeableTableViewSectionHeader else{
            return nil
            
        }
        
        var title = String.EMPTY
        switch section{
            case 0: title = ESSENTIAL_STRING_SHOPPING
            case 1: title = ESSENTIAL_STRING_INVENTORY
            case 2: title = ESSENTIAL_STRING_RECIPES
            default: title = ESSENTIAL_STRING_OTHER
        }
        
        header.title = title
        return header
    }
    
    //click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
            //shopping
            case 0: onShoppingSectionTriggeredAt(tableView,indexPath);
            //inventory
            case 1: onInventorySectionTriggeredAt(tableView,indexPath);
            default:
                print("Invalid Section value for settings")
        }
    }
    
    //help functions
    private func onShoppingSectionTriggeredAt(_ tableView : UITableView,_ indexPath: IndexPath){
        //nothing to do here :D
    }
    
    private func onInventorySectionTriggeredAt(_ tableView : UITableView,_ indexPath: IndexPath){
        if(indexPath.row == 1){
            //inventory sort
            guard let cell = tableView.cellForRow(at: indexPath) else{
                return
            }
            vc?.showValueChooserDialog(title: ESSENTIAL_STRING_CHOOSE, msg: MESSAGE_CHOOSE_INVENTORY_SORT_ALGORITHM, values: InventorySortAlgorithms.allCases, onChoose: {alg -> Void in
                HomiumSettings.instance.putUserSetting(value: alg.id , key: USER_SETTING_INVENTORY_SORT_ALGORITHM_ID)
                //sending notification that inventory needs to reload its data
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_SETTING_INVENTORY_SORT_CHANGED), object: nil, userInfo: nil)
                self.vc?.onInventorySortAlgorithmChanged(newAlgorithmName: alg.shortDescription)
            }, onCancel: {}, sender: cell)
        }
        else if(indexPath.row == 2){
            //inventory options
            guard let cell = tableView.cellForRow(at: indexPath) else{
                return
            }
            
            vc?.showValueChooserDialog(title: ESSENTIAL_STRING_CHOOSE, msg: MESSAGE_CHOOSE_INVENTORY_IMPORT_OPTION, values: InventoryImportOptions.allCases, onChoose: {
                let sucess = HomiumSettings.instance.putUserSetting(value: $0.id, key: USER_SETTING_INVENTORY_IMPORT_OPTIONS)
                self.vc?.onInventoryImportOptionsChanged(newOption: $0.shortDescription)
            }, onCancel: {}, sender: cell)
        }
    }
}
