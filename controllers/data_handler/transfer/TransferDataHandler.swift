//
//  TransferDataHandler.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 25.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

protocol TransferDataHandler{
    associatedtype SOURCE
    
    func transfer(src: SOURCE) -> Bool
}
