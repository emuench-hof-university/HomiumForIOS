//
//  PersistenceHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 23.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import CoreData

protocol PersistenceHandler{
    //func getContext() -> NSManagedObjectContext?
    func syncWithPersistenceLayer(context: NSManagedObjectContext) -> Bool
    //func for  loading data
    func loadData() -> Bool
}
