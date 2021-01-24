//
//  DataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 18.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//
import CoreData
import UIKit

protocol DataHandler{
    //type
    associatedtype T
    
    //functions
    func getData() -> T?
    
    func putData(data : T) -> Bool
    
    func delete() -> Bool
    
    func getContext()-> NSManagedObjectContext?
}
