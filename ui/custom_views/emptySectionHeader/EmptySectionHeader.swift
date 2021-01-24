//
//  EmptySectionHeader.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class EmptySectionHeader: UITableViewHeaderFooterView {
    
    //static variables
    static let reuseIdentifier = "EmptySectionHeader"
    
    //fields
    private let emptyView = UIView()
    
    //init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //configure()
    }
    
    //help functions
    private func configure(){
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(emptyView)
        
        //constraints
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: emptyView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emptyView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emptyView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: emptyView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 0, constant: 0)
        ])
    }
}
