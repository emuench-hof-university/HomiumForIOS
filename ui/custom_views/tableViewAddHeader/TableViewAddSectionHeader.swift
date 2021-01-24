//
//  TableViewAddSectionHeader.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class TableViewAddSectionHeader: UITableViewHeaderFooterView {
    
    //static fields
    static let reuseIdentifier : String = "TableViewAddSectionHeader"
    
    //fields
    private let lblTitle : UILabel = UILabel()
    private let btnAdd : UIButton = UIButton()
    
    //properties
    var title : String = String.EMPTY{
        willSet(newValue){
            lblTitle.text = newValue
        }
    }
    
    var onAddButtonClickListener : (UIButton) -> Void = {(btn: UIButton) -> Void in}
    
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
        //configure button style
        btnAdd.setImage(UIImage(systemName: "plus"), for: .normal)
        btnAdd.tintColor = UIColor.colorAccent
        
        //configure button actions
        btnAdd.addTarget(self, action: #selector(onAddButtonTouched(_:)), for: .touchUpInside)
        
        //configure Label Style
        lblTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        //create constraints
        createLayout()
        
    }
    
    private func createLayout(){
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        btnAdd.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(lblTitle)
        contentView.addSubview(btnAdd)
        
        //constraints
        NSLayoutConstraint.activate([
            //configure labelTitle Constraints
            lblTitle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            //lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            
            //configure Button Constraints
            btnAdd.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            btnAdd.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            //configure relations
            NSLayoutConstraint(item: btnAdd, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: lblTitle, attribute: .trailing, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: lblTitle, attribute: .centerY, relatedBy: .equal, toItem: btnAdd, attribute: .centerY, multiplier: 1, constant: 1),
            //height of content  view
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: btnAdd, attribute: .height, multiplier: 2, constant: 1),
        ])
    }
    
    //button touched call
    @objc private func onAddButtonTouched(_ sender: UIButton){
        onAddButtonClickListener(sender)
    }
    
    

    deinit {
        print("Header deinit")
    }
}
