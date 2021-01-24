//
//  IOSCoreExtensions.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

//ViewControllerExtensions
/*
extension UIViewController : SettingsDelegate{
    //write
    private func putSetting<T: Any>(value : T, key: String, domain : String) throws {
        //check if settings domain does exists and if not -> create it
        guard var settings = UserDefaults.standard.dictionary(forKey: domain) else {
            UserDefaults.standard.set([String : Any](), forKey: domain)
            
            guard var attempt2 = UserDefaults.standard.dictionary(forKey: domain)else {
                //throw Error if settings domain cam not be created
                throw IOSCoreError.CREATING_SETTINGS_DOMAIN_FAILED
            }
            
            //putting Data into Settings of domain
            attempt2[key] = value
            
            //setting new dictonary to domain
            UserDefaults.standard.set(attempt2, forKey: domain)
            return
        }
        print(settings)
        
        //putting Data into Settings of domain
        settings[key] = value
         //setting new dictonary to domain
        UserDefaults.standard.set(settings, forKey: domain)
        
    }
    
    
    func putUserSetting<T: Any>(value : T, key: String) -> Bool{
        do{
            try putSetting(value: value, key: key, domain: USER_DEFAULTS_DOMAIN_USER_SETTING)
            return true
        }
        catch{
            print(error)
            return false
        }
    }
    
    func putInternalSetting<T: Any>(value : T, key: String) -> Bool{
        do{
            try putSetting(value: value, key: key, domain: USER_DEFAULTS_DOMAIN_INTERNAL_SETTING)
            return true
        }
        catch{
            print(error)
            return false
        }
    }
    
    
    
    //read
    private func getSetting<T : Any>(key : String, domain : String) -> T?{
        let test : T? = UserDefaults.standard.dictionary(forKey: domain)?[key] as? T
        return test
    }
    
    func getUserSetting<T : Any>(key: String) -> T?{
        return getSetting(key: key, domain: USER_DEFAULTS_DOMAIN_USER_SETTING)
    }

    func getInternalSetting<T : Any>(key: String) -> T?{
        return getSetting(key: key, domain: USER_DEFAULTS_DOMAIN_INTERNAL_SETTING)
    }
}
*/
