//
//  OnBoardingViewController.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class OnBoardingViewController: BaseViewController {
    
    //actions
    @IBAction func btnBackTouched(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarIsHidden = true
    }

}
