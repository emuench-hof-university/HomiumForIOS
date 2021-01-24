//
//  ShoppingItemMO.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 18.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShoppingItemMO : NSManagedObject{
    @NSManaged var sid : UUID
    @NSManaged var title : String
    @NSManaged var quantity : Double
    @NSManaged var unit : String
}
