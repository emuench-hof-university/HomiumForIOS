//
//  ShoppingRefreshControl.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 24.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ShoppingRefreshControl: UIRefreshControl {

    var onValueChanged : (ShoppingRefreshControl) -> Void = {_ in}
    
    override init(){
        super.init()
        attributedTitle = NSAttributedString(string: MESSAGE_TRANSFER_SHOOPING_DATA_TO_INVENTORY_BY_SWIPE)
        tintColor = UIColor.colorAccent ?? UIColor.systemGray
        addTarget(self, action: #selector(onValueChangedRecognized), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //react on changes
    @objc private func onValueChangedRecognized(){
        onValueChanged(self)
    }
}
