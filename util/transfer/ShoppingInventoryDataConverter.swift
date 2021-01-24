//
//  ShoppingInventoryDataConverter.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 25.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

class ShoppingInventoryDataConverter : DataConverter{
    typealias SOURCE = [ShoppingItem]
    
    typealias TARGET = [InventoryItem]
    
    func convert(src: [ShoppingItem]) -> [InventoryItem] {
        var invItems = [InventoryItem]()
        
        for shop in src{
            let similarItemIdx = invItems.firstIndex(where: {inv in
                let invTitle = inv.title?.lowercased() ?? String.EMPTY
                let invUnit = inv.unit?.lowercased() ?? String.EMPTY
                let shopTitle = shop.title?.lowercased() ?? String.EMPTY
                let shopUnit = shop.unit?.lowercased() ?? String.EMPTY
                
                return (invTitle == shopTitle) && (invUnit == shopUnit)
            })
            
            if let simIdx = similarItemIdx{
                invItems[simIdx].quantity = invItems[simIdx].quantity + shop.quantity
            }
            else{
                let invItem = InventoryItem(entity: InventoryItem.entity(), insertInto: shop.managedObjectContext)
                invItem.location = String.EMPTY
                invItem.title = shop.title
                invItem.quantity = shop.quantity
                invItem.unit = shop.unit
                
                invItems.append(invItem)
            }
        }
        
        return invItems
    }
}
