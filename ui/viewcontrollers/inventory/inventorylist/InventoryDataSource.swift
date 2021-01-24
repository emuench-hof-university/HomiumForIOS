//
//  InventoryDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class InventoryDataSource: NSObject, UITableViewDataSource {
    
    //fields
    let dataHandler = InventoryListDataHandler()
    private var data : [(id: NSManagedObjectID,title: String, location : String, quantityDetails: String)] = []
    
    override init(){
      super.init()
        reloadData()
    }
    
    //protocol functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //getting cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryItemCell", for: indexPath) as? InventoryItemCell else{
            return UITableViewCell()
        }
        //assigning data to view
        let idx = indexPath.row
        cell.lblTitle.text = data[idx].title
        cell.lblQuantityDetails.text = data[idx].quantityDetails
        cell.lblLocation.text = data[idx].location
        cell.setQuantityIdicator(details: data[idx].quantityDetails)
        
        //returning cell
        return cell
    }
    
    //more datasource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //getting section title
        return getSectionTitle()
    }*/
    
    
    //help functions
    func reloadData(){
        data = dataHandler.getData() ?? []
    }
    
    func getIdAtIndex(index: Int) -> NSManagedObjectID?{
        if(index < 0 || index >= data.count){
            return nil
        }
        else{
            return data[index].id
        }
    }
    
    func getTitleAtIndex(index: Int) -> String{
        if(index < 0 || index >= data.count){
            return String.EMPTY
        }
        else{
            return data[index].title
        }
          
    }
    
    func getSectionTitle() -> String{
        if(data.count == 0){
            return MESSAGE_LOOKS_EMPTY
        }
        else if (data.count == 1){
            return ESSENTIAL_PHRASE_HEADLINE_INVENTORY.replacingOccurrences(of: "#", with: data.count.description).replacingOccurrences(of: "Produkte", with: "Produkt")
        }
        else{
            return ESSENTIAL_PHRASE_HEADLINE_INVENTORY.replacingOccurrences(of: "#", with: data.count.description)
        }
    }
}
