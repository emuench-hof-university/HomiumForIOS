//
//  NavigationPerformerDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 03.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

public protocol NavigationPerformerDelegate{
    func performSegue(identifier: String, sender: Any?)
}
