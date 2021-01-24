//
//  LaunchViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 01.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {
    
    private var appIsInitialized : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarIsHidden = true
        
        appIsInitialized = HomiumSettings.instance.getInternalSetting(key: INTERNAL_SETTING_APP_IS_INITIALIZED) ?? false
        
        print("isInitialized? \(appIsInitialized)")
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(switchVC(_:)), userInfo: nil, repeats: false)
        
        
    }
    
    
    @objc func switchVC(_ timer : Timer){
        timer.invalidate()
        if(appIsInitialized){
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SEGUE_LAUNCH_TO_MAIN_MENU, sender: nil)
            }
        }
        else{
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SEGUE_LAUNCH_TO_ONBOARDING, sender: nil)
            }
        }
    }

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
