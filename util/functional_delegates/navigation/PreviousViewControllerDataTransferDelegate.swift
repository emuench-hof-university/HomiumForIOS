//
//  PreviousViewControllerDataTransferDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import Foundation

public protocol PreviousViewControllerDataTransferDelegate : PreviousViewControllerDelegate{
    //function should be called when view resumed to prevoius screen and has Data to be transfered back to previous screen
    func onViewDataTransfered(data: [String:Any])
}
