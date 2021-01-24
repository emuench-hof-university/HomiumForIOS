//
//  RecipePresentationDescriptionCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 04.06.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class RecipePresentationDescriptionCell: UITableViewCell {
    
    //static variables
    static let reuseIdentifier = "recipePresentationDescriptionCell"

    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
