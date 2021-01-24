//
//  Dao.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 18.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation
import CoreData

protocol Dao{
    //generic type
    associatedtype T
    associatedtype UpdateParams
    
    //functions
    func insert(element : T) -> Bool
    func delete(id : NSManagedObjectID) -> T?
    func update(id : NSManagedObjectID, params : UpdateParams) -> Bool
    func get(id: NSManagedObjectID) -> T?
    func getAll() -> [T]
    func clear() -> Bool
}
