//
//  MessageDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

protocol MessageDelegate{
    func showMessage(title : String, msg: String)

    func showAlertDialog(title: String, msg: String, onYes : @escaping () -> Void, onNo : @escaping () -> Void, isDestructiveOperation : Bool, noIsDestructiveToo : Bool)
}
