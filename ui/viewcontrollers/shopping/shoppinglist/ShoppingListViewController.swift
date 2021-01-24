//
//  ShoppingListViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 22.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ShoppingListViewController: UITableViewController, PreviousViewControllerDelegate, NavigationPerformerDelegate{
    
    
    //fields
    private let dataSource = ShoppingListDataSource()
    private let delegate = ShoppingListDelegate()
    
    @IBOutlet private weak var btnShare: UIBarButtonItem!
    //actions
    @IBAction private func onShareButtonTouched(_ sender: UIBarButtonItem) {
        let ac = UIActivityViewController(activityItems: [MESSAGE_SHARE_SHOPPINGLIST.replacingOccurrences(of: "#", with: "\n\(dataSource.shareableShoppingListText())")], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac,animated: true)
    }
    
    
    //functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension;
        self.tableView.estimatedSectionHeaderHeight = 40
        tableView.register(ResizeableTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: ResizeableTableViewSectionHeader.reuseIdentifier)
        
        //datasource
        btnShare.isEnabled = dataSource.count != 0
        dataSource.onDataCountChanged = { cnt in
            if cnt <= 0{
                self.btnShare.isEnabled = false
            }
            else{
                self.btnShare.isEnabled = true
            }
        }
        tableView.dataSource = dataSource
        
        //delegate
        delegate.messageDelegate = self
        delegate.navigationPerformerDelegate = self
        tableView.delegate = delegate
        
        //refresh control
        let refresher = ShoppingRefreshControl()
        refresher.onValueChanged = {cntrl in
            self.delegate.onDataTransfer(in: self.tableView)
            cntrl.endRefreshing()
        }
        refreshControl = refresher
        
    }
    
    func viewDidResume() {
        dataSource.reloadData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //show tabbar when view appears
        tabBarController?.tabBar.isHidden = false
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    func performSegue(identifier: String, sender : Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
            case SEGUE_SHOPPINGLIST_TO_EDIT : prepareShoppingListToEditSegue(segue,sender)
            default:
                print("DEBUG: something went wrong with prepare in shoppinglist VC")
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    private func prepareShoppingListToEditSegue(_ segue : UIStoryboardSegue, _ sender : Any?){
        if let destination = segue.destination as? ShoppingItemEditViewController{
            if let senderCell = sender as? ShoppingItemCell{
                let id = dataSource.getIdAtIndex(index: tableView.indexPath(for: senderCell)?.row ?? -1)
                destination.dataHandler = ShoppingItemEditDataHandler(id: id)
            }
            else{
                destination.dataHandler = ShoppingItemEditDataHandler(id: nil)
            }
            //link parent to destination
            destination.previousVC = self
            
            //hide tab bar
            tabBarController?.tabBar.isHidden = true
        }
    }

}
