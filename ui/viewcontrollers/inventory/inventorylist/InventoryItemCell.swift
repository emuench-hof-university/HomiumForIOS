//
//  InventoryItemCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 08.05.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class InventoryItemCell: UITableViewCell {

    //outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblQuantityDetails: UILabel!
    @IBOutlet weak var quantityIndicator: UIView!
    
    //lifecycle functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //help functions
    func setQuantityIdicator(details quantityDetails: String){
        let color = Units.quantityIndicatorColor(details: quantityDetails)
        quantityIndicator.backgroundColor = color
    }

}
