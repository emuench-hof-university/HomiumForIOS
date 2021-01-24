//
//  AutoShrinkLabel.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 09.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class AutoShrinkLabel: UILabel {

    override func awakeFromNib() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.25
    }

}
