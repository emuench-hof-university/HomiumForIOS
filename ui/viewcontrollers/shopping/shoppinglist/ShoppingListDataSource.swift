//
//  ShoppingListDataSource.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 22.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListDataSource: NSObject, UITableViewDataSource {
    //fields
    let dataHandler = ShoppingListDataHandler()
    private var data : [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)] = []
    var count : Int{
        return data.count
    }
    var onDataCountChanged : (Int) -> Void = {_ in}
    
    override init(){
        super.init()
        reloadData()
    }
    
    //functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //getting cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingItemCell", for: indexPath) as? ShoppingItemCell else{
            return UITableViewCell()
        }
        //assigning data to view
        let idx = indexPath.row
        cell.lblTitle.text = data[idx].title
        cell.lblDetails.text = data[idx].quantityDetails
        cell.setSelectState(isSelected: data[idx].isSelected)
        
        //returning cell
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //getting section title
        return getSectionTitle()
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func reloadData(){
        let newData = dataHandler.getData() ?? []
        if data.count != newData.count{
            onDataCountChanged(newData.count)
        }
        
        data = newData
        
    }
    
    func reloadAtIndex(index : Int){
        if(index < data.count && index >= 0){
            if let newData = dataHandler.getDataWithId(id: getIdAtIndex(index: index)) {
                data[index] = newData
            }
        }
    }
    
    func getIdAtIndex(index: Int)-> NSManagedObjectID?{
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
    
    func getSelectedProductsWithIndex() -> [(idx: Int, value: (id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String))]{
        var result = [(idx: Int, value: (id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String))]()
        
        for (index, element) in data.enumerated(){
            if element.isSelected{
                result.append((idx: index, value: element))
            }
        }
        
        return result
    }
    
    func getSectionTitle() -> String{
        if(data.count == 0){
            return MESSAGE_LOOKS_EMPTY
        }
        else if (data.count == 1){
            return ESSENTIAL_PHRASE_HEADLINE_SHOPPINGLIST.replacingOccurrences(of: "#", with: data.count.description).replacingOccurrences(of: "Produkte", with: "Produkt")
        }
        else{
            return ESSENTIAL_PHRASE_HEADLINE_SHOPPINGLIST.replacingOccurrences(of: "#", with: data.count.description)
        }
    }
    
    func shareableShoppingListText() -> String{
        return data.map{
            return "\($0.quantityDetails) \($0.title)"
        }.joined(separator: "\n")
    }
    
}
