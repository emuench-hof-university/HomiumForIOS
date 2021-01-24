//
//  DataConverter.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 25.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

protocol DataConverter {
    associatedtype SOURCE
    associatedtype TARGET
    
    func convert(src: SOURCE) -> TARGET
}
