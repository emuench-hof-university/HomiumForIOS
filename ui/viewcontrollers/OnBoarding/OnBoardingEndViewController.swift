//
//  OnBoardingEndViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class OnBoardingEndViewController: BaseViewController {

    //actions
    @IBAction func btnBackTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnFinishTouched(_ sender: UIButton) {
        //persist that user has completed onboarding
        let appIsInitialized = HomiumSettings.instance.getInternalSetting(key: INTERNAL_SETTING_APP_IS_INITIALIZED) ?? false
        
        if(!appIsInitialized){
            HomiumSettings.instance.putInternalSetting(value: true, key: INTERNAL_SETTING_APP_IS_INITIALIZED)
            HomiumSettings.instance.initializeUserSettings()
        }
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarIsHidden = true
    }
    
    

}
