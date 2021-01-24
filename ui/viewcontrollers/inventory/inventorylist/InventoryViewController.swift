//
//  InventoryViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventoryViewController: UITableViewController, PreviousViewControllerDelegate {
    //fields
    private let dataSource = InventoryDataSource()
    private let delegate = InventoryDelegate()
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 40
        tableView.register(ResizeableTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier)
        
        //assign delegate + datasource
        tableView.dataSource = dataSource
        
        delegate.messageDelegate = self
        tableView.delegate = delegate
        
        //register for recieving information when sort of list changed
        NotificationCenter.default.addObserver(self, selector: #selector(onInventorySortChanged(_:)), name: NSNotification.Name(rawValue: NOTIFICATION_SETTING_INVENTORY_SORT_CHANGED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onInventoryItemsImportd(_:)), name: NSNotification.Name(NOTIFICATION_INVENTORY_ITEMS_IMPORTED_FROM_SHOPPINGLIST), object: nil)
        
        //first reload --> necessary because otherwise changes for sort or imports would not be recognized because they send notifications but observer is not registered yet
        reload()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //show tabbar when view appears
        tabBarController?.tabBar.isHidden = false
    }


    //protocol fuctions
    func viewDidResume() {
        reload()
    }
    
    //react on sort changes
    @objc private func onInventorySortChanged(_ notification: Notification){
        reload()
    }
    
    //react to imports from shoppinglist
    @objc private func onInventoryItemsImportd(_ notification: Notification){
        reload()
    }
    
    deinit {
        //unregister for recieving information when sort of list changed
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_SETTING_INVENTORY_SORT_CHANGED), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION_INVENTORY_ITEMS_IMPORTED_FROM_SHOPPINGLIST), object: nil)
    }
    
    private func reload(){
        dataSource.reloadData()
        tableView.reloadData()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier){
            case SEGUE_INVENTORYLIST_TO_EDIT: prepareInventoryListToEditSegue(segue,sender)
            case SEGUE_INVENTORYITEM_TO_EDIT : prepareInventoryListToEditSegue(segue,sender)
            default:
                print("DEBUG: Invalid segue identifier")
        }
    }
    
    private func prepareInventoryListToEditSegue(_ segue : UIStoryboardSegue, _ sender : Any?){
        
        if let destinationVC = segue.destination as? InventoryItemEditViewController{
            //setting navigation parent
            destinationVC.previousVC = self
            
            //setting data handler depending of if data exists
            if let senderCell = sender as? InventoryItemCell{
                let itemid = dataSource.getIdAtIndex(index: tableView.indexPath(for: senderCell)?.row ?? -1)
                destinationVC.dataHandler = InventoryItemEditDataHandler(id: itemid)
                
                //changing cells selected state
                senderCell.setSelected(false, animated: true)
            }
            else{
                destinationVC.dataHandler = InventoryItemEditDataHandler(id: nil)
            }
            
        }
        
        //hide tabbar when navigation is started
        tabBarController?.tabBar.isHidden = true
    }
}
