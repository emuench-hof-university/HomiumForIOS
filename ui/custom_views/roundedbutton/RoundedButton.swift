//
//  RoundedButton.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 07.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RoundedButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        //setting corner radius
        layer.cornerRadius = CGFloat(8)
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 2, bottom: 16, right: 2)
        
    }
    
}

