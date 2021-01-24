//
//  UIPresenterDelegate.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 10.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

protocol UIPresenterDelegate {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (()-> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
