//
//  ChooserDialogDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 13.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

protocol ChooserDialogDelegate{
func showValueChooserDialog<T : CustomStringConvertible>(title: String ,msg: String ,values: [T], onChoose: @escaping (T) -> Void, onCancel : @escaping () -> Void, sender: UIView)
    
}
