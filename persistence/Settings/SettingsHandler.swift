//
//  SettingsDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

protocol SettingsHandler {
    func putUserSetting<T: Any>(value : T, key: String) -> Bool
    
    func putInternalSetting<T: Any>(value : T, key: String) -> Bool
    
    func getUserSetting<T : Any>(key: String) -> T?

    func getInternalSetting<T : Any>(key: String) -> T?
}
