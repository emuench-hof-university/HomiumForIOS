//
//  ResizeableTableViewSectionHeader.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 29.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ResizeableTableViewSectionHeader : UITableViewHeaderFooterView{
    //static fields
    static let reuseIdentifier : String = "ResizeableTableViewSectionHeader"
       
    //fields
    private let lblTitle : UILabel = UILabel()
           
    //properties
    var title : String = String.EMPTY{
        willSet(newValue){
            lblTitle.text = newValue
            ajustSize()
        }
    }
       
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
        //configure Label Style
        lblTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
           
        //create constraints
        createLayout()
           
    }
       
    private func createLayout(){
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(lblTitle)
           
        //constraints
        NSLayoutConstraint.activate([
               //configure labelTitle Constraints
               lblTitle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
               lblTitle.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
               lblTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               //height of content  view
            NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: lblTitle, attribute: .height, multiplier: 1.5, constant: 1),
           ])
        
        ajustSize()
    }
    
    private func ajustSize(){
        lblTitle.sizeToFit()
        var frame = contentView.frame
        frame.size.height = frame.size.height + lblTitle.frame.size.height + 8.0
        contentView.frame = frame
    }
}
