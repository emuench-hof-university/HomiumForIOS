//
//  ShoppingItemCell.swift
//  HomiumForIOS
//
//  Created by Eric Münch on 22.04.20.
//  Copyright © 2020 Eric Münch. All rights reserved.
//

import UIKit

class ShoppingItemCell: UITableViewCell {

    //Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var imageState: UIImageView!
    
    //functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSelectState(isSelected : Bool){
        if isSelected{
            imageState.tintColor = .systemGreen
        }
        else{
            imageState.tintColor = .systemRed
        }
        
        
    }
    

}
