//
//  ShoppingInventoryTransferDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 25.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData

class ShoppingInventoryTransferDataHandler : TransferDataHandler{
    //type
    typealias SOURCE = [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)]
    
    //fields
    private let converter : ShoppingInventoryDataConverter = ShoppingInventoryDataConverter()
    private let shoppingDao = DataStorage.shoppingDao
    private let inventoryDao = DataStorage.inventoryDao
    
    //protocol functions
    func transfer(src: [(id: NSManagedObjectID,title: String, isSelected: Bool, quantityDetails: String)]) -> Bool {
        //get shopping items
        let shoppingItems = src.compactMap{
            return shoppingDao.get(id: $0.id)
        }
        
        if src.count != shoppingItems.count{
            //something seems to be invalid
            return false
        }
        
        var newShoppingItems = [ShoppingItem]()
        shoppingItems.forEach{shop in
            let similarItem = inventoryDao.getSimilarItem(for: shop)
            
            if let simItem = similarItem{
                //similar items are existing --> update existing items
                inventoryDao.update(id: simItem.objectID, params: (title: simItem.title ?? String.EMPTY, quantity: simItem.quantity + shop.quantity, unit: simItem.unit ?? String.EMPTY, location: simItem.location ?? String.EMPTY))
            }
            else{
                //no similar items --> can be converted
                newShoppingItems.append(shop)
            }
        }
        
        //get inventoryitems after conversion
        let inventoryItems = converter.convert(src: newShoppingItems)
        
        //do insert
        let insertSuccess = inventoryDao.mergeAll(in: inventoryItems)
        
        if !insertSuccess{
            //inserting failed
            return false
        }
        
        //do delete
        return shoppingDao.deleteAll(in: shoppingItems)
        
    }
    
}
